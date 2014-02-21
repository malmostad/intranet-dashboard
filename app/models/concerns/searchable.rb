module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    settings YAML.load_file("#{Rails.root.to_s}/config/elasticsearch.yml")

    # Override model name
    index_name    "employees"
    document_type "employee"

    mappings dynamic: 'false' do
      indexes :username, analyzer: 'simple'
      indexes :displayname, analyzer: 'simple'
      indexes :name_suggest, index_analyzer: 'displayname_index', search_analyzer: 'displayname_search'
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
    def suggest(query)
    end
  end
end
