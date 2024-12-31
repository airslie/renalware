module FaradayHelper
  def mock_faraday_response(
    status: 200,
    body: {},
    raw_body: nil,
    content_type: :json,
    headers: nil
  )
    headers ||= case content_type
                when :json then { "Content-Type" => "application/json" }
                else { "Content-Type" => "application/octet-stream" }
                end
    instance_double(
      Faraday::Response,
      status: status,
      body: body,
      headers: headers,
      env: { raw_body: raw_body }
    )
  end
end
