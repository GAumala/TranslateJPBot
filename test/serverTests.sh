url=http://localhost:4000/telegram/MYTOKEN
test_update_payload_with_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}, \"text\": \"増加\"}}" -i $url && printf "\n\n"
}

test_update_payload_with_no_message() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234}" -i $url
}

test_update_payload_with_no_message_text() {
  curl -H "Content-Type: application/json" -d "{\"update_id\": 11234, \"message\": {\"message_id\":1, \"date\":6, \"chat\": {\"id\":1}}}" -i $url
}
