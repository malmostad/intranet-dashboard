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
      indexes :username, analyzer: 'simple'
      indexes :displayname, analyzer: 'simple'
      indexes :displayname_suggest, index_analyzer: 'displayname_index', search_analyzer: 'displayname_search'
      indexes :displayname_suggest_2, index_analyzer: 'simple_ngram_2', search_analyzer: 'displayname_search'
      indexes :username_2, index_analyzer: 'simple_ngram_2', search_analyzer: 'displayname_search'
      indexes :name_suggest, type: 'completion', analyzer: 'simple', payloads: true
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
      displayname_suggest: "#{first_name}#{last_name} #{last_name}#{first_name} #{username}",
      displayname_2: displayname,
      username_2: username,
      name_suggest: {
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

# Autocomplete for suggestion names or phone numbers
# TODO: phone numbers are matching from the back, intentionally
# so no suggetsion is made before at least the five last digits are entered
#
# POST /users/_search
# {
#    "size": 2000,
#    "fields": [
#       "displayname",
#       "username",
#       "company_short",
#       "department"
#    ],
#    "query": {
#       "bool": {
#          "should": [
#             {
#                "match": {
#                   "displayname_suggest": {
#                      "query": "asdasdasdasdasdas",
#                      "fuzziness": 0.8,
#                      "prefix_length": 0
#                   }
#                }
#             },
#             {
#                "multi_match": {
#                   "fields": [
#                      "phone",
#                      "cell_phone"
#                   ],
#                   "query": "341029"
#                }
#             }
#          ]
#       }
#    }
# }





# EdgeNgram start matching for autocompletion.
# Matches "first last", "last first", "username" from start with fuzziness in percent or edition distance
#
# POST /users/_search
# {
#    "size": 2000,
#    "fields": ["displayname", "username", "company_short", "department"],
#    "query": {
#       "match": {
#          "displayname_suggest": {
#             "query": "bylund jes",
#             "fuzziness": 0.8,
#             "prefix_length": 0
#          }
#       }
#    }
# }

# Fast elastic suggest completion.
# No scoring for exact matches.
#
# POST /users/_suggest
# {
#    "users_suggest" : {
#     "text" : "carlsson",
#     "completion" : {
#       "size": 1000,
#       "field" : "name_suggest",
#         "fuzzy": {
#             "edit_distance": 1,
#             "prefix_length": 0,
#             "unicode_aware": true
#         }
#     }
#   }
# }

# Matches phone number from the end.
# Ignores everything non-digit. Possible to match front-truncated 5 digit numbers
#
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
#          "query": "040-341139"
#       }
#    }
# }

# Query on selected fields. Swedish snowball filter
#
# POST /users/_search
# {
#     "query": {
#         "query_string": {
#             "query": "personalavin",
#             "fields": ["skills", "professional_bio"]
#         }
#     }
# }
