module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings analysis: {
      analyzer: {
        swedish_ngram_2: {
          language: "Swedish",
          tokenizer: "ngram_2",
          filter: ["swedish_snowball"]
        },
        simple_ngram_2: {
          tokenizer: "keyword",
          filter: ["lowercase", "edge_start_2"]
        },
        edge_ngram_2: {
          tokenizer: "edge_ngram_2",
          filter: ["lowercase"]
        },
        displayname_index: {
          tokenizer: "edge_ngram_2",
          filter: ["lowercase"]
        },
        displayname_search: {
          tokenizer: "keyword",
          filter: ["lowercase"],
          char_filter: ["name_suggest"]
        },
        swedish_snowball: {
          language: "Swedish",
          tokenizer: "standard",
          filter: ["swedish_snowball"]
        },
        phone_number: {
          tokenizer: "keyword",
          filter: ["phone_number"],
          char_filter: ["phone_number"]
        }
      },
      tokenizer: {
        ngram_2: {
          type: "nGram",
          min_gram: 2,
          max_gram: 10,
          token_chars: ["letter", "digit"]
        },
        edge_ngram_2: {
          type: "edgeNGram",
          min_gram: 2,
          max_gram: 50,
          token_chars: ["letter", "digit"]
        },
        comma: {
          type: "pattern",
          pattern: "\\s*,\\s*"
        }
      },
      filter: {
       swedish_snowball: {
         type: "snowball",
         language: "Swedish"
        },
        phone_number: {
          type: "edgeNGram",
          side: "back",
          min_gram: 5,
          max_gram: 12
        },
        edge_start_2: {
          type: "edgeNGram",
          min_gram: 2,
          max_gram: 50
        }
      },
      char_filter: {
        phone_number: {
          type: "pattern_replace",
          pattern: "[^0-9]",
          replacement: ""
        },
        letters_digits: {
          type: "pattern_replace",
          pattern: "[^\\w\\d]",
          replacement: " "
        },
        normalize_space: {
          type: "pattern_replace",
          pattern: "\\s+",
          replacement: " "
        },
        name_suggest: {
          type: "pattern_replace",
          pattern: "[-,\\s]",
          replacement: ""
        },
        phonetic_mappings: {
          type: "mapping",
          mappings: ["ph=>f", "c=>k", "sch" => "sk"]
        }
      }
    }

    # Override model name
    index_name    "employees"
    document_type "employee"

    mappings dynamic: 'false' do
      indexes :id, index: 'not_analyzed'
      indexes :username, index_analyzer: 'simple_ngram_2', search_analyzer: 'displayname_search'
      indexes :first_name, index_analyzer: 'simple_ngram_2', search_analyzer: 'displayname_search'
      indexes :last_name, index_analyzer: 'simple_ngram_2', search_analyzer: 'displayname_search'
      indexes :displayname, analyzer: 'simple'
      indexes :name_suggest, index_analyzer: 'displayname_index', search_analyzer: 'displayname_search'
      indexes :name_suggest_2, index_analyzer: 'edge_ngram_2', search_analyzer: 'edge_ngram_2'
      indexes :name_completion, type: 'completion', analyzer: 'simple', payloads: true
      indexes :professional_bio, analyzer: 'swedish_snowball'
      indexes :professional_bio_2, analyzer: 'swedish_ngram_2'
      indexes :skills, analyzer: 'swedish_snowball'
      indexes :languages, analyzer: 'swedish_snowball'
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
      name_suggest: "#{first_name}#{last_name} #{last_name}#{first_name} #{username}",
      name_suggest_2: "#{first_name} #{last_name} #{username}",
      first_name: first_name,
      last_name: last_name,
      name_completion: {
        input: [first_name, last_name, "#{last_name} #{first_name}", displayname, username],
        output: displayname,
        weight: 34,
        payload: {
          username: username,
          company_short: company_short,
          department: department
        }
      },
      professional_bio: professional_bio,
      professional_bio_2: professional_bio,
      skills: skills.map { |m| m.name },
      languages: languages.map { |m| m.name },
      phone: phone,
      cell_phone: cell_phone,
      company_short: company_short,
      department: department
    }.as_json
  end

  module ClassMethods
    def query(query)
      # ...
    end
  end
end

# GET /_cluster/health
# GET /_aliases

# GET /employees/_mapping
# GET /employees/_optimize
# GET /employees/_count
# GET /employees/employee/111
# GET /employees/employee/115
# GET /employees/employee/1416
# GET /employees/_search?q=professional_bio_2:strategi
# GET /employees/_analyze?tokenizer=standard&text=Mårten

# GET /employees/_search?q=skill:responsiv+design
 
# POST /employees/_search
# {
#    "size": 200,
#    "fields": [
#       "displayname",
#       "phone",
#       "cell_phone"
#    ],
#    "query": {
#       "multi_match": {
#          "fields": [
#             "phone",
#             "cell_phone"
#          ],
#          "query": "41029"
#       }
#    }
# }

# POST /employees/_search
# {
#    "size": 2000,
#    "fields": [
#       "displayname",
#       "username"
#    ],
#    "query": {
#       "multi_match": {
#          "fields": [
#             "name_suggest"
#          ],
#          "query": "je byl",
#          "fuzziness": 2,
#          "prefix_length": 0
#       }
#    }
# }

# POST /employees/_search
# {
#    "size": 2000,
#    "fields": [
#       "displayname",
#       "username",
#       "company_short",
#       "department",
#       "phone",
#       "cell_phone"
#    ],
#    "query": {
#       "bool": {
#          "should": [
#             {
#               "multi_match": {
#                  "boost": 10,
#                  "fields": [
#                     "name_suggest"
#                  ],
#                  "query": "jesper b"
#               }
#             },
#             {
#               "multi_match": {
#                  "boost": 1,
#                  "fields": [
#                     "name_suggest"
#                  ],
#                  "query": "jesper b",
#                  "fuzziness": 2,
#                  "prefix_length": 0
#               }
#             }
#          ]
#       }
#    }
# }

# POST /employees/_search
# {
#    "size": 2000,
#    "fields": [
#       "displayname",
#       "username"
#    ],
#    "query": {
#       "multi_match": {
#          "fields": [
#             "name_suggest_2"
#          ],
#          "query": "jesby ylund",
#          "fuzziness": 2,
#          "prefix_length": 0
#       }
#    }
# }

# POST /employees/_search
# {
#    "size": 2000,
#    "fields": [
#       "displayname",
#       "username",
#       "company_short",
#       "department",
#       "phone",
#       "cell_phone"
#    ],
#    "query": {
#       "bool": {
#          "should": [
#             {
#               "multi_match": {
#                  "fields": [
#                     "name_suggest"
#                  ],
#                  "query": "341029",
#                  "fuzziness": 2,
#                  "prefix_length": 0
#               }
#             },
#             {
#                "multi_match": {
#                   "fields": [
#                      "phone",
#                      "cell_phone"
#                   ],
#                   "query": "040341029"
#                }
#             }
#          ]
#       }
#    }
# }


# POST /employees/_search
# {
#     "query": {
#         "query_string": {
#             "query": "Komin",
#             "fields": ["skills"]
#         }
#     }
# }

# POST /employees/_search
# {
#    "size": 2000,
#    "fields": ["displayname", "username", "company_short", "department"],
#    "query": {
#       "match": {
#          "name_suggest": {
#             "query": "jepser b",
#             "fuzziness": 1,
#             "prefix_length": 0
#          }
#       }
#    }
# }

# POST /employees/_suggest
# {
#    "users_suggest": {
#       "text": "carlsson",
#       "completion": {
#          "size": 1000,
#          "field": "name_completion",
#          "fuzzy": {
#             "edit_distance": 1,
#             "prefix_length": 0,
#             "unicode_aware": true
#          }
#       }
#    }
# }

# POST /employees/_search
# {
#    "size": 1000,
#    "query": {
#     "fuzzy_like_this" : {
#         "fields" : ["displayname"],
#         "like_text" : "bylund jepser",
#         "min_similarity": 0.8
#     }
#   }
# }

# POST /employees/_search
# {
#    "size": 20,
#    "query": {
#     "fuzzy_like_this" : {
#         "fields" : ["displayname", "skills", "languages", "professional_bio", "username", "phone", "cellphone"],
#         "like_text" : "040342091",
#         "min_similarity": 1
#     }
#   }
# }

