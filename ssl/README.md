# Generate Public/Private Key For Password Security
`openssl genrsa -out key.pem 4096`
`openssl rsa -in key.pem -pubout > key.pub`

