# frozen_string_literal: true

module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  # Em request spec os headers sao um argumento de cada chamada (get/post/...),
  # nao um objeto mutavel: `request` so passa a existir depois da requisicao.
  # Por isso estes helpers montam e devolvem hashes.
  module HeadersHelpers
    def api_header(version = 1)
      { 'Accept' => "application/vnd.marketplace.v#{version}+json" }
    end

    def api_response_format(format = 'application/json')
      { 'Content-Type' => format }
    end

    def include_default_accept_headers
      api_header.merge(api_response_format)
    end

    # Usado como `headers: headers` nos specs.
    def headers
      include_default_accept_headers
    end
  end
end
