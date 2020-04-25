url_correios = "https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente"
url_geolocation = "https://geolocation.tst.eu.daedalus.fih.io/country/213.127.2.175"
url_httpstatus = "httpstat.us/200"

# # Hackney
# hackney = Tesla.client([], {Tesla.Adapter.Hackney, []})
# hackney_proxy = Tesla.client([], {Tesla.Adapter.Hackney, [proxy: {"localhost", 8888}]})

# # Mint
# mint = Tesla.client([], {Tesla.Adapter.Mint, []})
# mint_proxy = Tesla.client([], {Tesla.Adapter.Mint, [proxy: {:http, "localhost", 8888, []}]})

# # Gun
# gun = Tesla.client([], {Tesla.Adapter.Gun, []})
# gun_proxy = Tesla.client([], {Tesla.Adapter.Gun, [proxy: {'localhost', 8888}]})

# Tesla.get(hackney, url_correios)
# Tesla.get(hackney_proxy, url_correios)
# HTTPoison.get("https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente", [{"User-Agent", "curl/123"}], proxy: {"127.0.0.1", 8888}, ssl: [verify: :verify_none, versions: [:"tlsv1.2"]])

# :hackney.post(url_correios, [{"Accept", "text/plan"}], [], with_body: true)

# :hackney.post(url_correios, [{"Accept", "text/plan"}], [],
#   with_body: true,
#   proxy: {"127.0.0.1", 8888}
# )

headers = [{"Content-Type", "text/xml; charset=utf-8"}]

body = """
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
  <soapenv:Header />
  <soapenv:Body>
    <cli:consultaCEP>
      <cep>13212-070</cep>
    </cli:consultaCEP>
  </soapenv:Body>
</soapenv:Envelope>
"""

# :hackney.post(url_correios, headers, body, with_body: true, recv_timeout: 5000)

# :hackney.post(url_correios, headers, body,
#   with_body: true,
#   recv_timeout: 5000,
#   proxy: {"127.0.0.1", 8888}
# )

# :hackney.post(url_correios, headers, body, with_body: true, proxy: {"127.0.0.1", 8888})

host = "jsonplaceholder.typicode.com"
path = "/todos"
headers = [{"Content-Type", "application/json; charset=utf-8"}]
body = ~s({"title": "foo", "body": "bar", "userId": 1})

# opts = [transport_opts: [ciphers: :ssl.cipher_suites(:default, :"tlsv1.2")]]
# {:ok, conn} = Mint.HTTP.connect(:https, host, 443, opts)
# {:ok, conn} = Mint.HTTP.connect(:https, host, 443)
# {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "POST", path, headers, body)
# {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "GET", path, headers, body)

# {:ok, conn} = Mint.HTTP.connect(:http, "httpbin.org", 80)
# {:ok, conn, request_ref} = Mint.HTTP.request(conn, "GET", "/", [], "")

# {:ok, conn} = Mint.HTTP.connect(:https, "apps.correios.com.br", 443)

# {:ok, conn} = Mint.HTTP.connect(:https, "httpstat.us", 443)

# {:ok, conn, request_ref} =
#   Mint.HTTP.request(conn, "GET", "/200", [{"Content-Type", "text/plain"}], "")

# {:ok, conn, request_ref} =
#   Mint.HTTP.request(conn, "POST", "/201", [{"Content-Type", "application/json"}], "{}")

# :httpc.request('https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente')

# url = 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente'
# headers = [{'Accept', 'text/xmll'}]
# content_type = 'text/xml; charset=utf-8'

# body =
#   String.to_charlist("""
#   <?xml version="1.0" encoding="UTF-8"?>
#   <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">
#     <soapenv:Header />
#     <soapenv:Body>
#       <cli:consultaCEP>
#         <cep>13212-070</cep>
#       </cli:consultaCEP>
#     </soapenv:Body>
#   </soapenv:Envelope>
#   """)

# :httpc.request(:post, {url, headers, content_type, body}, [], [])

# :httpc.set_options([{:proxy, {{'localhost', 8888}, []}}])

# url = 'https://httpstat.us/201'
# url = 'https://jsonplaceholder.typicode.com/todos'
# headers = [{'Accept', 'application/json'}, {'Content-Type', 'application/json; charset=utf-8'}]
# body = '{"title": "foo", "body": "bar", "userId": 1}'
# proxy = [proxy_host: 'localhost', proxy_port: 8888]

# # :ibrowse.send_req(url, headers, :post, [body], proxy)

# {:ok, conn} = :gun.open('localhost', 8888)
# {:ok, :http} = :gun.await_up(conn)
# # ref = :gun.connect(conn, %{host: 'httpstat.us', port: 443})
# ref = :gun.connect(conn, %{host: 'apps.correios.com.br', port: 443})
# {:response, :fin, 200, _} = :gun.await(conn, ref)

# ref = :gun.get(conn, '/200', headers)
# :gun.await(conn, ref)
# :gun.await_body(conn, ref)

# {:ok, conn} = :gun.open('httpstat.us', 443)
# {:ok, :http} = :gun.await_up(conn)
# ref = :gun.get(conn, '/200', headers)
# :gun.await(conn, ref)
# :gun.await_body(conn, ref)

# # {:ok, conn} = Mint.HTTP.connect(:https, "apps.correios.com.br", 443)

# {:ok, conn} = :gun.open('apps.correios.com.br', 443)
# :gun.await_up(conn)

# {:ok, conn} = :gun.open('apps.correios.com.br', 443)
# :gun.await_up(conn, 30000)

options = %{tls_opts: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]}
{:ok, conn} = :gun.open('apps.correios.com.br', 443, options)
:gun.await_up(conn)

options = [transport_opts: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]]
Mint.HTTP.connect(:https, "apps.correios.com.br", 443, options)

options = [
  proxy: {:http, "localhost", 8888, []},
  transport_opts: [ciphers: ['AES256-SHA256'], versions: [:"tlsv1.2"]]
]

Mint.HTTP.connect(:https, "apps.correios.com.br", 443, options)
