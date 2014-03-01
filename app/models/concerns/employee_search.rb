module EmployeeSearch
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    settings YAML.load_file("#{Rails.root.to_s}/config/elasticsearch.yml")

    # Override model name
    index_name    "employees_#{Rails.env}"
    document_type "employee"

    mappings dynamic: 'false' do
      indexes :username, analyzer: 'simple'
      indexes :displayname, analyzer: 'simple'
      indexes :name_suggest, index_analyzer: 'name_suggest_index', search_analyzer: 'name_suggest_search'
      indexes :phone, analyzer: 'phone_number'
      indexes :cell_phone, analyzer: 'phone_number'
      indexes :company_short, analyzer: 'simple'
      indexes :department, analyzer: 'simple'
    end
  end

  def as_indexed_json(options={})
    {
      id: id,
      username: username,
      displayname: displayname,
      company_short: company_short,
      department: department,
      phone: phone,
      cell_phone: cell_phone,
      name_suggest: "#{first_name}#{last_name} #{last_name}#{first_name} #{username}"
    }.as_json
  end

  module ClassMethods
    def fuzzy_search(query, options = {})
      return false if query.blank?
      settings = {
        from: 0, size: 10
      }.merge(options)
      begin
        Rails.cache.fetch(["employee_fuzzy_search", query, settings], expires_in: 12.hours) do
          query = sanitize_query(query)
          __elasticsearch__.search({
            from: settings[:from],
            size: settings[:size],
            query: {
              bool: {
                should: [
                  {
                    match: {
                      name_suggest: {
                        query: query,
                        fuzziness: 2,
                        prefix_length: 0
                      }
                    }
                  },
                  {
                    match: {
                      name_suggest: {
                        query: query,
                        fuzziness: 0,
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
          })
        end
      rescue Exception => e
        logger.error "Elasticsearch: #{e}"
        false
      end
    end

    def fuzzy_suggest(query, options = {})
      users = fuzzy_search(query, options)
      if users
        users.map(&:_source)
      else
        false
      end
    end

  private

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
