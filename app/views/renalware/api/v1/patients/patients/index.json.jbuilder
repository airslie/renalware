def modify_query(url, options = {})
  uri = URI(url)
  query_hash = Rack::Utils.parse_query(uri.query)
  query_hash.merge!(options)
  uri.query = Rack::Utils.build_query(query_hash)
  uri.to_s
end

json.links do
  json.prev patients.prev_page && modify_query(request.url, "page" => patients.prev_page)
  json.next patients.next_page && modify_query(request.url, "page" => patients.next_page)
  json.total_pages patients.total_pages
  json.next_page patients.next_page
  json.current_page patients.current_page
  json.prev_page patients.prev_page
end

json.data patients do |patient|
  json.id patient.id
  json.secure_id patient.secure_id
  json.local_patient_id patient.local_patient_id
  json.local_patient_id_2 patient.local_patient_id_2
  json.local_patient_id_3 patient.local_patient_id_3
  json.local_patient_id_4 patient.local_patient_id_4
  json.nhs_number patient.nhs_number
  json.family_name patient.family_name
  json.given_name patient.given_name
  json.title patient.title
  json.born_on patient.born_on
  json.sex patient.sex&.code
  json.send_to_renalreg patient.send_to_renalreg
  json.send_to_rpv patient.send_to_rpv
end
