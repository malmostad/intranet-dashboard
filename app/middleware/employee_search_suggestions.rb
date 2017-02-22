require "elasticsearch"

class EmployeeSearchSuggestions
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] == "/employee_search_suggestions"
      request = Rack::Request.new(env)
      employees = suggest(request.params["term"])

      if request.params['callback']
        # jsonp
        response = "#{request.params['callback']}(#{employees.to_json})"
      else
        response = employees.to_json
      end
      [200, {"Content-Type" => "application/json; charset=utf-8"}, [response]]
    else
      @app.call(env)
    end
  end

  def suggest(term)
    term = sanitize_query(term)
    client = Elasticsearch::Client.new
    employees = client.search(index: 'employees', body: {
      size: 10,
      query: {
        bool: {
          should: [
            {
              match: {
                name_suggest: {
                  query: term,
                  fuzziness: 2,
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
                query: term
              }
            }
          ]
        }
      }
    })["hits"]["hits"]

    employees.map { |employee|
      employee = employee["_source"]
      { username: employee["username"],
        avatar_full_url: "https://profilbilder.malmo.se/#{employee["username"]}/tiny_quadrat.jpg",
        path: "/users/#{employee["username"]}",
        displayname: employee["displayname"],
        company_short: employee["company_short"] || "",
        department: employee["department"] || ""
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
