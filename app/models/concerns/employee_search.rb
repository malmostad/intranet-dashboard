module EmployeeSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    settings Rails.application.config.elasticsearch

    after_create do
      __elasticsearch__.index_document
    end

    after_touch do
      __elasticsearch__.index_document
    end

    after_update do
      # If the user is deactivated, delete ES document
      if deactivated?
        delete_document
      else
        __elasticsearch__.index_document
      end
    end

    after_destroy do
      delete_document
    end

    def delete_document
      # ES document might already be deleted, so we do not log errors unless debug
      begin
        __elasticsearch__.delete_document
      rescue => e
        logger.debug { "Document could not be deleted: #{e}" }
      end
    end

    # Override model name
    index_name    "employees_#{Rails.env}"
    document_type "employee"

    mappings dynamic: 'false' do
      indexes :username, analyzer: 'simple', type: 'text'
      indexes :displayname_phrase, analyzer: "simple", type: 'text'
      indexes :displayname, analyzer: 'name_index', search_analyzer: 'name_search', type: 'text'
      indexes :phone, analyzer: 'phone_number', type: 'text'
      indexes :cell_phone, analyzer: 'phone_number', type: 'text'
      indexes :company_short, analyzer: 'simple', type: 'text'
      indexes :department, analyzer: 'simple', type: 'text'
    end
  end

  def as_indexed_json(options={})
    {
      id: id,
      username: username,
      displayname: displayname,
      displayname_phrase: displayname,
      company_short: company_short,
      department: department,
      phone: phone,
      cell_phone: cell_phone
    }.as_json
  end

  module ClassMethods
    def fuzzy_search(query, options = {})
      return false if query.blank?
      settings = {
        from: 0, size: 10
      }.merge(options)
      begin
        response = __elasticsearch__.search fuzzy_query(query, settings[:from], settings[:size])

        { employees: response.records.to_a, # to_a is needed to be able to serialize for memcached
          total: response.results.total,
          took: response.took
        }
      rescue => e
        logger.error "Elasticsearch: #{e}"
        false
      end
    end

    def fuzzy_suggest(query)
      begin
        response = __elasticsearch__.search fuzzy_query(query, 0, 10)
        response.map(&:_source)
      rescue => e
        logger.error "Elasticsearch: #{e}"
        false
      end
    end

  private

    def fuzzy_query(query, from, size)
      query = sanitize_query(query)
      {
        from: from,
        size: size,
        query: {
          bool: {
            should: [
              { # very fuzzy
                match: {
                  displayname: {
                    query: query,
                    fuzziness: 2,
                    prefix_length: 0
                  }
                }
              },
              { # boost exact match
                match: {
                  displayname: {
                    boost: 5,
                    query: query
                  }
                }
              },
              { # boost exact phrase
                match_phrase_prefix: {
                  displayname_phrase: {
                    boost: 10,
                    query: query
                  }
                }
              },
              {
                match: {
                  username: {
                    query: query,
                    prefix_length: 0
                  }
                }
              },
              {
                multi_match: {
                  fields: [
                    "phone",
                    "cell_phone"
                  ],
                  query: query
                }
              }
            ]
          }
        }
      }
    end

    # NOTE: The sanitizer does not allow grouping and operators in the query
    def sanitize_query(query)
      # Remove Lucene reserved characters
      query.gsub!(/([#{Regexp.escape('\\+-&|!(){}[]^~*?:/"\'')}])/, '')

      # Remove Lucene operators
      query.gsub!(/\s+\b(AND|OR|NOT)\b/i, '')
      query
    end
  end
end
