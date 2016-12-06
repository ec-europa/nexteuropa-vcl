sub vcl_backend_error {
  if(beresp.status > 499) {
    if(bereq.http.X-Fpfis-Hint ~ ";DebugAccess") {
      call render_debug_error_page;
    } else {
      call render_error_page;
    }
  }
}
sub render_debug_error_page {
    synthetic( {"<html><head>
<title>Nexteuropa - Error</title>
<meta http-equiv='content-type' content='text/html; charset=utf-8'/>
<style type='text/css'>#footer {padding:10px;}#footer a {padding-left:5px; padding-right:5px;}.level_1{display:inline-block;width:30%;border-bottom:#ffd617 2px solid;margin-left:5px;margin-right:5px;font-size:14pt;padding:15px;font-weight:bolder;}.level_1 p{font-weight:normal;}a:link{color:white;}a:visited{color:white;}a:hover{color:#ffd617;}a:active{color:#ffd617;}body{font-family:Arial,Helvetica Neue,Helvetica,sans-serif;background-color:#004494;margin:0px;padding:0px;padding-bottom:10px;}#header{text-align:center;-moz-box-shadow:inset 0px -5px 5px 0px #004494;-webkit-box-shadow:inset 0px -5px 5px 0px #004494;-o-box-shadow:inset 0px -5px 5px 0px #004494;box-shadow:inset 0px -5px 5px 0px #004494;filter:progid:DXImageTransform.Microsoft.Shadow(color=#004494,Direction=90,Strength=5);-moz-border-radius:0px;-webkit-border-radius:0px;text-align:center;border-radius:0px;height:284px;background-color:#ffffff;background-position:center top 10px;background-repeat:no-repeat;background-image:url('data:image/gif;base64,R0lGODlh7gEAAee5AABMpQBNoANOoQdPoglQnAtQowBUngxRnQBUpQBUpg5RpABXmxBTmRFSpRJUmgBamBRUoQNapgBdlRdVohZXlwZbpxlWoxtXpBlalB1YpRtblRxdkB1ekR1gjR9fkh9hjh9kiyFljCxiih5lqy1miCNpii5miS1ohC5phS9qhi5sgjdqgS9tgyhsrDdufzhvgDlwgThyfDlzfUB0eUF1ej1yrkJ2e0d2dkB5eEh3d0Z6c0d7dEh8dU58cU99clN+bU2Abk6Bb1OCa1SDbFWEbVmFaFqGaVuHal+IZWCJZmGKZ2WLY2WMZGaNZWmNX2SPYGqOYGuPYWiRXG6QXGmSXWqTXnCSXm2UWW6VWm+WW3KXVnOYV3SZWHeaU3ucT3mcVXydT32eUH6fUYGgTIKhTYOiToekSYilSoqmRYunRoyoR5CqQpGrQ5OtRZWuPpewQJ6vOZixQZ+wOqCxO6GyPKSzNaOzPaW0Nqe2Oai4Oqq5Mqu6M6y7NK+8LK68NrC9LbG+L7K/MLPAMbXBKLbCKbfDK7nELLrFLbzGI77IJre8v8TIKMbJHL/KJ768wLi+wMLMHbm/wcnLH8rMIc3OE8vNI87QFs/RGNDSGtLTHNPUHtbWDdfXENjYE9nZFd3bANvaF97dANzcGt/eA+DfB+HgC+TiEuviAOnhE+zjAO3kAO7lAPDmA/HnB/LoC/TpAPPpD/XqAPbrAPftAPnuAPrvAPvwAP3xAPzxBf///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////yH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAP8ALAAAAADuAQABAAj+AP8JHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMZIJlNafKSypcuXMGPKnAnzEUqaOP/ZzMmzp8+fQINOfERU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');}</style>
</head>
<body>
<div id='header'>
</div>
<div id='content' style='color: #ffffff; text-align: center;'>
<h2>
The requested resource is currently unavailable
</h2>
<em>request-id: "} + bereq.xid + {"</em>
<div class='euBox'>
<div class='level_1 euItem euNbr_0 euSeqNr_1 euFirst'>
The EUROPA server is temporarily unavailable
<p>We apologise for any inconvenience this may cause you.</p>
</div>
<div class='level_1 euItem euNbr_1 euSeqNr_2 euZebra'>
Serveris EUROPA šobrīd nav pieejams
<p>Mēs atvainojamies par sagādātajām neērtībām.</p>
</div>
<div class='level_1 euItem euNbr_2 euSeqNr_3'>
Поради технически причини нашият сървър временно не работи.
<p>Моля извинете ни за всички евентуални неудобства, причинени от това.</p>
</div>
<div class='level_1 euItem euNbr_3 euSeqNr_4 euZebra'>
EUROPA serveris laikinai neveikia
<p>Atsiprašome dėl nepatogumų.</p>
</div>
<div class='level_1 euItem euNbr_4 euSeqNr_5'>
Server EUROPA je dočasně nedostupný
<p>Omlouváme se za případné nepříjemnosti, které vám tím mohou vzniknout.</p>
</div>
<div class='level_1 euItem euNbr_5 euSeqNr_6 euZebra'>
Szerverünk műszaki okok miatt jelenleg nem elérhető
<p>A kényelmetlenségért elnézést kérünk.</p>
</div>
<div class='level_1 euItem euNbr_6 euSeqNr_7'>
EUROPA-serveren er midlertidigt utilgængelig
<p>Vi beklager.</p>
</div>
<div class='level_1 euItem euNbr_7 euSeqNr_8 euZebra'>
Is-server EUROPA għalissa mhux disponibbli
<p>Niskużaw ruħna għal kull inkonvenjenza li dan jista’ joħloqlok.</p>
</div>
<div class='level_1 euItem euNbr_8 euSeqNr_9'>
Der EUROPA-Server steht zurzeit leider nicht zur Verfügung
<p>Wir bitten um Ihr Verständnis.</p>
</div>
<div class='level_1 euItem euNbr_9 euSeqNr_10 euZebra'>
De Europa server is tijdelijk niet beschikbaar
<p>Onze excuses voor het eventuele ongemak.</p>
</div>
<div class='level_1 euItem euNbr_10 euSeqNr_11'>
EUROPA server on ajutiselt kättesamatu
<p>Vabandame tekkinud ebamugavuste pärast.</p>
</div>
<div class='level_1 euItem euNbr_11 euSeqNr_12 euZebra'>
Serwer EUROPA jest chwilowo niedostępny
<p>Przepraszamy za wszelkie związane z tym niedogodności.</p>
</div>
<div class='level_1 euItem euNbr_12 euSeqNr_13'>
Ο διακομιστής (server) EUROPA είναι προσωρινά μη διαθέσιμος
<p>Ζητάμε συγγνώμη για τυχόν προβλήματα που θα αντιμετωπίσετε.</p>
</div>
<div class='level_1 euItem euNbr_13 euSeqNr_14 euZebra'>
O servidor EUROPA está momentaneamente indisponível
<p>Pedimos desculpa pelo inconveniente.</p>
</div>
<div class='level_1 euItem euNbr_14 euSeqNr_15'>
El servidor EUROPA no funciona por el momento
<p>Disculpe las molestias.</p>
</div>
<div class='level_1 euItem euNbr_15 euSeqNr_16 euZebra'>
Din motive tehnice, serverul nostru este momentan indisponibil
<p>Ne cerem scuze pentru inconvenientele cauzate.</p>
</div>
<div class='level_1 euItem euNbr_16 euSeqNr_17'>
Le serveur EUROPA est temporairement indisponible
<p>Nous sommes désolés de l’inconvénient que cela peut vous causer.</p>
</div>
<div class='level_1 euItem euNbr_17 euSeqNr_18 euZebra'>
Server EUROPA je dočasne nedostupný
<p>Ospravedlňujeme sa za prípadné problémy, ktoré môžu v dôsledku toho vzniknúť.</p>
</div>
<div class='level_1 euItem euNbr_18 euSeqNr_19'>
De bharr cúiseanna teicniúla ní bheidh ár bhfreastalaí ar fáil go ceann tamaill
<p>Is dona linn aon trioblóid a chuirtear ort dá bharr.</p>
</div>
<div class='level_1 euItem euNbr_19 euSeqNr_20 euZebra'>
Strežnik EUROPA je začasno nedosegljiv
<p>Opravičujemo se vam za vse morebitne nevšečnosti.</p>
</div>
<div class='level_1 euItem euNbr_20 euSeqNr_21'>
Poslužitelj EUROPA privremeno je nedostupan
<p>
<span>Ispričavamo se zbog mogućih neugodnosti.</span>
</p>
</div>
<div class='level_1 euItem euNbr_21 euSeqNr_22 euZebra'>
EUROPA-palvelin on väliaikaisesti poissa käytöstä
<p>Pahoittelemme tästä mahdollisesti aiheutuvaa haittaa.</p>
</div>
<div class='level_1 euItem euNbr_22 euSeqNr_23'>
Il server EUROPA è momentaneamente inaccessibile
<p>Ci scusiamo degli inconvenienti che questo le può causare.</p>
</div>
<div class='level_1 euItem euNbr_23 euSeqNr_24 euZebra euLast'>
EUROPA-servern kan för närvarande inte nås
<p>Vi beklagar att detta kan vålla dig problem.</p>
</div>
</div>
<pre style=' border-bottom: #ffd617 solid 5px; 
text-align:left; display: inline-block; padding:15px;font-family: Courier New,Courier,Lucida Sans Typewriter,Lucida Typewriter,monospace;'>
ERROR "} + beresp.status + {"<br/>
URL: "} + bereq.url + {"<br/>
Host: "} + bereq.http.host + {"<br/>
Cookie: "} + bereq.http.cookie + {"<br/>
User-Agent: "} + bereq.http.user-agent + {"<br/>
<br/>
Proxy: "} + server.hostname + {"<br/>
Backend: "} + beresp.backend.name + {"<br/>
<br/>
X-FPFIS-Application-Name: "} + bereq.http.X-FPFIS-Application-Name + {"<br/>
X-FPFIS-Application-BasePath: "} + bereq.http.X-FPFIS-Application-BasePath + {"<br/>
X-FPFIS-Application-Path: "} + bereq.http.X-FPFIS-Application-Path + {"<br/>
X-FPFIS-Application-Session: "} + bereq.http.X-FPFIS-Application-Session + {"<br/>
</pre>
</div>
<div id='footer' style='text-align:center;  color: #ffd617;'>
<a href='http://ec.europa.eu/sitemap/index_en.htm' class='first'>Sitemap</a>
|
<a href='http://ec.europa.eu/geninfo/legal_notices_en.htm' accesskey='2'>Legal notice</a>
|
<a href='http://ec.europa.eu/cookies/index_en.htm' accesskey='3'>Cookies</a>
|
<a href='http://ec.europa.eu/contact/index_en.htm' accesskey='4'>Contact</a>
|
<a href='http://ec.europa.eu/geninfo/query/search_en.html' accesskey='5'>Search</a>
</div>
</body></html>
"});
  return(deliver);
}
sub render_error_page {
    synthetic( {"<html><head>
<title>Nexteuropa - Error</title>
<meta http-equiv='content-type' content='text/html; charset=utf-8'/>
<style type='text/css'>#footer {padding:10px;}#footer a {padding-left:5px; padding-right:5px;}.level_1{display:inline-block;width:30%;border-bottom:#ffd617 2px solid;margin-left:5px;margin-right:5px;font-size:14pt;padding:15px;font-weight:bolder;}.level_1 p{font-weight:normal;}a:link{color:white;}a:visited{color:white;}a:hover{color:#ffd617;}a:active{color:#ffd617;}body{font-family:Arial,Helvetica Neue,Helvetica,sans-serif;background-color:#004494;margin:0px;padding:0px;padding-bottom:10px;}#header{text-align:center;-moz-box-shadow:inset 0px -5px 5px 0px #004494;-webkit-box-shadow:inset 0px -5px 5px 0px #004494;-o-box-shadow:inset 0px -5px 5px 0px #004494;box-shadow:inset 0px -5px 5px 0px #004494;filter:progid:DXImageTransform.Microsoft.Shadow(color=#004494,Direction=90,Strength=5);-moz-border-radius:0px;-webkit-border-radius:0px;text-align:center;border-radius:0px;height:284px;background-color:#ffffff;background-position:center top 10px;background-repeat:no-repeat;background-image:url('data:image/gif;base64,R0lGODlh7gEAAee5AABMpQBNoANOoQdPoglQnAtQowBUngxRnQBUpQBUpg5RpABXmxBTmRFSpRJUmgBamBRUoQNapgBdlRdVohZXlwZbpxlWoxtXpBlalB1YpRtblRxdkB1ekR1gjR9fkh9hjh9kiyFljCxiih5lqy1miCNpii5miS1ohC5phS9qhi5sgjdqgS9tgyhsrDdufzhvgDlwgThyfDlzfUB0eUF1ej1yrkJ2e0d2dkB5eEh3d0Z6c0d7dEh8dU58cU99clN+bU2Abk6Bb1OCa1SDbFWEbVmFaFqGaVuHal+IZWCJZmGKZ2WLY2WMZGaNZWmNX2SPYGqOYGuPYWiRXG6QXGmSXWqTXnCSXm2UWW6VWm+WW3KXVnOYV3SZWHeaU3ucT3mcVXydT32eUH6fUYGgTIKhTYOiToekSYilSoqmRYunRoyoR5CqQpGrQ5OtRZWuPpewQJ6vOZixQZ+wOqCxO6GyPKSzNaOzPaW0Nqe2Oai4Oqq5Mqu6M6y7NK+8LK68NrC9LbG+L7K/MLPAMbXBKLbCKbfDK7nELLrFLbzGI77IJre8v8TIKMbJHL/KJ768wLi+wMLMHbm/wcnLH8rMIc3OE8vNI87QFs/RGNDSGtLTHNPUHtbWDdfXENjYE9nZFd3bANvaF97dANzcGt/eA+DfB+HgC+TiEuviAOnhE+zjAO3kAO7lAPDmA/HnB/LoC/TpAPPpD/XqAPbrAPftAPnuAPrvAPvwAP3xAPzxBf///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////yH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAP8ALAAAAADuAQABAAj+AP8JHEiwoMGDCBMqXMiwocOHECNKnEixosWLGDNq3Mixo8ePIEOKHEmypMZIJlNafKSypcuXMGPKnAnzEUqaOP/ZzMmzp8+fQINOfERUqMuiRpMqXcq0qUakTkUSZRm1qtWrWHtCzcpx6k2uYMOKHTtR0U6yGKdSRcu2rVusU99WVLtWrt27eGduzduQLt+/gAN3JPpVcEK6dQ0rXsx4YNzGBxEnhky58tu9liVb3syZ7OPOkid3Hk06aSTMmSU7Ks269c/Po0OLdk27dsnTs1OHts27t1TUm83K9k28+EXYpWXnNs68OUHkrJU7n05doNeEhSsPr869uFqFywP+35TevXxt4cuBGz5tfbv596ShEzSbnfHp8bvh698s37H69UiRt9+Ai02lCHjhCYYbVQIS6CBf3x32H4CPuffghXJFiFB/9mloIYYgjnWdhAlSWGF+IaYIFnoIlmjiiZqpKKNVGm54VmcLGthejDP2qNSCC3EIWY6PESmkj0jqdeSRjRl51odJRimTWgdix2SHkuGH2GpSdlnTVFwi5MiVjW0HpZdoirRgmDa62KSZKKYp50dUBjkhf3AiNueeg9UY2Z2cuRcnn4QO5adBh7ZG3pmFNkoiYXYCClqefjlqaYtLkhkbioNe6mmOVT7al2Xs+Rcjo54SqiemfbmJ12n+YY6Z5Y6Vpuooj23eqemrWwmKq617/opoogXtymuv+aGnVn3AermqQrICKulfOT6XX6fNRinssFdOS22tvj6bbZLKMllrizieGy6x46Y4a6TSevututdu2y6G2HIbr6uAOWktYlXme++AqP67b2lO1sWpuAM7KHBB1TJkrHhxhnZTtOw23F1oocLbsagIW2gxrSNq/F7BxWY8EJCKjmwquAybPJ1ybMLL7J/8FigywC9PLDNp5Z4rscqm2pZwXQmTLO/Pk6Ksr4s+M9bgwkIzTZty8tJ1s76+Tc0jz1a7hvXSMefq3c6r2hs2ZUGrjekjH4NcW2ICokhk3GvrPPb+0jpVTSLeiKaWMq5UE523XBiPPZffbQKesm4Gi9u2QEEf/tfebsOrqeFRu1Wj1zAzbjlYiWPe+T+Tt9ot3xmCGfmyr69V9uhREWa60wwZ+VCdQ+d8l9BJ9/zZ7LRrdfvtT2UeuepNI4c272AXP+XRx2PdlfIGO/7v1nr7+fzwokvPEX3Vl2+79hRxDFH4L29K18ffQ0W8+BGVbv79v2Gfveq+52Wh/Qo71fzoZy3q3a96JQEgv9jXvvhYKHhKkx0D8/YIWbXtgNWLRM1MYj2IKMshhuse4Sr2rAEOjCiKuCAGD6gk2XAvV+hrYHQ+FD+qEEljtluhDr2ywSkpLiL+N1TdC3XzqzhVTmmpsuAOl3i6kMBtb4YKYQi1Q0Nc6Q6JacohE5eowaQgL4o64l/XHkjC0LGuO0rcohqZosKHac5NUwyU+oQHmxJOcGY2UaMeu9gU/FXkimI0ToNSJ7xCVieNemQiH/towB+uxIQkcw7o6AW7SPYmhYnMJKSYosYY8m9zcdSOQVQ4OEp+JnG0aaQmj7dIoCjCEW1c4kbcuDwQDhFCk2lQ38Rlx1C+aJXlAwowOXbL9dGyZ7u7UZng9jShFdGM/evXMLHWSppUcJrUBAkAkznFJqLlUEcjiL/oSDJPYmma1YzJNZ+IzQ7mD5LI5GY021I1Ug6EkLv+/MwHWaNKFk4plu2E5yxxF08QbpKKrislL0foIV9Kc4XpNIkGA1o9c4JEORa1pEGVSZno0XEvZUThyzJKsdvhpiUUrag3N0K9Yvash1biaEeFVcVzleued1SQI0eyToCmVH8uiSVJ87nAldJzWzX9XK32mS6bwHR8efxpBp/qEyhKRKC0Ig0EY7cVI3Wsl2fkTU+l6kenmC59Of1HxNyH1DiNU6NYZY1PyaqciPZxrswEY9YcejldRhBZzmwoXwVDJbpiECz9jKtCi2pUu7iTqwE0ZV6JOk+34NWwfr2KIxJ7zLft9aAtO9OgGAq+wbaFs4YtFVfWqUOXepaxjc3+SxtxFljJvq4yqEXnmLAyUU2q9jhA1ShvFCia0dYWsLHNSm63aFehTHS5K+xTXBVLxLYuVLIS5N05h0lVnhgIs6415vuumlYHYiuksGEq6qiLFuhaVZiYzVJYP1ne4M6wU1slLd3Gqxj3mtYjrI0vx2TqxHBGBDHhFSVtYxY/hS52qGPp50StKeC9CQfCyZPNUDvbtAVXzbg1uul87CsWIzWXp8TN5AgqwOIWu/jFMGZxBC5ggQkgQAEKGICOd8zjHvv4x0AO8gAQYIEIxNjFFxDyjyFgZBgXQMlQjrKUp0zlHgOATvLxK4jTW0mcak0/rL3sKi1Q5TKb+cxoTrP+mtfM5ilfGcCJ0vIzlXooDvMHPWKmK5nbzOc++/nPgA70m6Wb5TmKU7/7PdQ27/zdCpfvwg0ItKQnTelKT3rQ1/ObnMUVREMuNrlebLSjD3ifhFj61KhOtaqFjOmBlm3TXabsYnPF3qX4d9QTjsiqd83rXgO61Rn+cjPrjGiFco+gUbk1RYXTXV37+tnQjraUgZ2RzBqYq7W8LXguSBZlrxLDzpa2uMctbWqnJbOwdh6xJ5jZZKd2vhcht7znvWtzAxfdUCr2px8CQHDTxNum2+1P6E3wgl/aifjulL4XG952O5eJFw5KmKeyZ4Nb/OJptne1M3vB+nj01SSmbBj+TXPYnCjCvRXHuMpXDmWNbzzhmr5uf0LOVbMExYC5hsnJx8xySy+g55R2eUbaiLfzynyyn67sX+Hmb+n+loPKyvMOUw70P3/gClWXtNCDbd2Yx5p4W723ne9a2FFTPOuBvkIh0P7rlDz2ox7+aviQbUvJ2Fwp7ESh2Y9HdbazuRC0+Lnf+bx1Vxsd5N5joN2bLibZNNsjkcDNzveuxkgPvs0MmMUthnD5NheepRr2MGoY5lGEhD3TdIcIwCmfQ1N3ns1CuMUt7PD6NX9+fa+Nc9dBCs/US+SCdz8J603HbN/Vfs10kL0qjp9xLKfH0NhuZkGO6JBrIzw0j1fI6rH+yXiDMN8BG4iyD4ZA/vKnQva30EL5y/+AKPfg+LeXp0LsmXQP1//Avv/92xuy/R2epvsPwXxLsARRpgKfgH4ImICyRwtdEGUykAfw53z/AXO6t26xJl6lBxLc9hD9Z2FRlRPMlwh6IGUYkAgKqICqkANShgapEIFwJjoUCB3CYj9iV2vrwzLVl0jFpxTH1wG3sHxSRgBscILopwkiMGWdcAspUHvxt1EXmHSigU8CAUgjZoNV+D5K1xHeBoA8FXmS0Xds5wWy9wJUBgW0cIJ84ABTlgKylwVMKIFPCFm5JCxUyFUJBi0bKBOq9H8SF1XmA4ZoxwmyBwZVZgYKuAn+VRYGsjcIb/iCbpNuhcYu+dc7GXgbT3RSOaF3fqhHgFh1MIB+l4ADojiKLiBki3CCGBBkMDCKo6gJsgcLrCiKNoB2TUhfdPFU9Bc79vcoVph78GYUryR1idSJFvcBjKAKyIiMsUCEt1AJHxBkD3CGCpgEQWYCmMCMCVgKM0CLcGh3vOh1I6dtuceFtKZdtiZqw/cIxGhxBrAG2Ih+cXAAQnYE6IcHWKB5t7AHQtaO73gLiCABbFeLtjg/osVfs5Y7k4h/0KcSedeQ6Yg163hxSbCMROgKnKdkenALs4AFOqYCoHALriCPQhYErUCEtCAGgyeQAzl3h1eB4fhG//X+ECrUfTuXQh2YjggweCbgigpoCSAAZQTQCp2wAjzmABmJA1BmjQqojZenkispOk5SdIhXMk6IYCkxkxJxk5TneoPHABSJgFIQZTngB4LXY0pgBlH2BQooB53nlFUpMIu2b7tIXglZFsGllQGlXgF4eTFwgmsHZQAZZIGpZDyJgKpAAE2ZQDs1bMVlkA9Wg4XFkN6Cl1tEPllYEJ13BggojbRAAZXGhrJXCQcoezSQmBy0mNEnl6LHdWXnE5R5P+TYEJ2XhLdACjbAAh95C0hQaYZ4C3hgAAvAB7KnBqZ5mvv3UXMoOjTYFcB3mRbxmgATkxtxeSgge3zQfgPgAHf+cAt8UGkH2IA7ZoafUJxud5xLN2y5FxKz5RKUGZshcXle4ApK4GNKgAoGMGkxoAo64GMu8AkqkJIf8UKxlJ4QM0B1+ZTOuRDQpZdWoXLvF2Rp8Iw/ZgIhMGlQ8JM/RgExIGQr4AEX55Y2ApO3+I2YUYeiJ1Il4XAYoUruyZCvhIVnZ3EecAnHNwZU8KHOhz6oCXef5kkq6hFYmTzBJxREMSaTJ4x0EZHRdgW3cISvpwmIgKOOGB4GRKKNmVMqlH2z1HFW8aJll1JKCm0m6IadJwK3QAvYWXAgGnciyiEtGUc7ShKT14tXtVlz+pBqEaa+Fo23kAivtwWyR40Gt6b+jLkcLUWiJ5ozY9OilHhGywKdAqanvbYE6KcBnQcJsucHFkeoUBge5qlWu3c6kbCeR6GQeDqM5GYCLrCqrFoI6OcFrMqqg0lwBhCrq2oD6BcLMGCrLoCY4sapcvgfpDpszPKjDkF0fXiqS6QsOTZuIXCN/Sh7d6CGFqcEX/mOrlAE5AasyJkxcZovxupBd1pe76SsWEM+Q4oQ83YA7viOs+AEK1cChcmMl1Ch29qNbvSpahOudsmv+Mp6UZeFBEeSzMgJS8hyBgAH2HgH9ylv3BqsQkJciGqlKHp9qiGZZqcSBfesJzitWWetCpitBPewneqtqJI540queiVsFvv+bSr7ngVXBArYmWyHCAoIgSNLEpjjixVUjgRWLNSjped2oIV6PFEXFQaXkQp4BGhHAdKIgK0gkvNGsonKkvnyVkHSRnf4nBrWdBXFFgV3AK6wgCZonWiHBOjXCaWAfjyQs+X5qSLnpsHlU0fhrz2ztVnxCM06bz0ge6WwoUqgebHQsEDXB5m6AA8wCLL3Bm77tnB7su9iqqGHUnTKSRqEG9AlqaqmsIGQph55Cz9QdQYQCxvJY1hAC6fQuBirou12oKo0Q3a6IEj6hwRXCijZY0Y5B1UXBEPpYy/wCRs6teqENU/lcES7dI3GFkWqReaquaj2ATAQZNoKdD1ArT7+9gBIKbw+xLoP40IdkWK/mBGRJyujOrvmShTOy3zqS3h0goGokoslq56N9BKQmo7pu77423xw5lpxep4UC2pF+5IgUb/Dd7/5e8BVRrJp1b9x+b/h2yrDyhEETFcBSxAIfMEHN6U/67MmqzyNxKgOvFITrEcVLBEYfMJ/psAc1r/ItrN1C7fa95AgLBAEx5EoHAM3oL2EtiXy9Ih2dlY1YX0ImZeRORP0JgOggMIDcAZ0oMOo18Ley8H941NCO6Wqt6xFvBT0lga3UAIo3AmxwAAO+69Ypa9jZxCwNDZ42xIfnMVjQW8f+QUnXJ26OcZkLFBm7I0akbI8LHECZxj+T0ZuoEkJJwwGsveX40a1yGuObdqzUpyg3aoWVawbjhAtXki75KaIsuehF3wJ6MfJv6qzLtwQ8Bu/8vteWWEWr2TJI1w9BtxmP9AFsjzLuXkLejDLsyyhaHcAU4DLXaDJ1unLXWCvvKbIJdtN74tRxqlho+q457tEr8xmBhAH0XoLsGAEl/cBZduPpetrxozGe5N9eWy3L8fMjNrKZhfNbQay2IgJxHx5XfC0RGiw0PbNVXtHUfzI0rmyC/lHz6xG6txmO8mMDMt8L0CbHWu93jy8MAxZ6DNX29u/CvrPWxTQbWaUCjgL06u+DLCdCUgLBFhuLeSvxhpwFNbQh0b+0cR3i8EXyNLWBScYfvhbBSfopNFmzwgqKSh9PJmIVei8QsIhefNEbpVwgk+QvzargGR60951rm85Rai1xlp4xRQMoxorbhuAfqBgBtLIiOvrtLJHCmWAj34q0j0RS8VEzjqRZ0zRgeWSrgMnblMge3/gmb+rkWV5fEkge4LQfrgpe5bK1EBaWRIth4ujUkBhQEGtd2ArboXQzTq2AH5wCxt9fH5wkkWZkUxg1jv8SPyqzBkBvgg2yeYhbgsACtHrY1hQB+prAJwgAz+mBN0p2DscVoUdyRdltJBMG+LmAXndYyigvhuQpj4W3LT9xKZ125SD0kOLOSc2N4RRyRj+k5NKXN36W9uOGREDmtNSPRGohXcGUslac8kw2k4Wbd0XrMLZhFaO18NnjNx1Rdr/INoqjTnnjd4HrN6oTJcX6xD0jRMQzYH1PXX4XeBudsfYVxERvBD0vdsXsVlp9dOOdt8Grr7GjEDsfcaJJd88IeEVRuGSZtyv59tSylM87d1qvchZwuH0O+A6BOKAtgCI3HlYUNmqa+Kms7XMbXr+lNguPmAsPRkYh7ap+HqJoI+bGlRf1K80ZxDuJRw44eHn6hVFCtcYgXGTPZ+dF42Dm+Q6t+SSm93lbD5WriaZhB6y+8AacXEGAAu38AevxwSy5wNeHtHKfRBViuOwGRL+R9M2UE4WF/cDsjcLCs12gSB7cFDnJz028n3n8H07MwwYFzcH6BcEl5d5yqfoPb3fAr7e6oRJK73BpSFvP6AK1XwL7syO7VrNayC1x+2ao6zde9Pd1zO/vGF549YBkhCtBT3k10qErXCRiQzeni4Rov3nr+GH7vvj5QPja0YAmsmM19xzJpAJ2GgJNj3snMTpHuTcah4TUh5fzs5mpX6CqQ50/HiCrU5vKpzbjh7C/e1uzH4/485mRDCzv91zrpqAeKCm3YjgDxx5lzV5JDfvmExvbnCCbZt1YruU/q7BRQrwDr5eGVSxMxHumFXva7a2ygePaNe3shcLT5vaTmz+eO/dqCeP4mUlUQZ/8PLWlxqJBQkre6mbdXIgewbrArmJluwu8d+u4hMPQogUzgPM7MqyJsjufQSnmZ9A8iAL21WHCrfgsQOwAHtwC51w46zJ7Rdh69419MTb9amFGxAe6UpPb51Q1z0mr2lAb4XuYzTwrj5mhibQ8xAPxNjNskERjABV5jyOOUcPJn6vxfQWAjbsYwbgBULmASSvakxwsEAWBZDfYy5ABHaf9yfeEQBF66u7z3/BfFhwBrwWCGHggi1bPiyuzy/rKCGYxKuWeZhg+qLc41AF+GYfIsfHpyewakMge9kOoC9sPqkP73qcKsdHqbeg+KqGB23YiDH+0eBWKRVImvQ+3vKuXHuHfguWgGaES2UEYOp96vyLHkwlAeoYBEtRbv3Xn3U3EIs7gI+3EASxiAPdD2QeMAVQZgBkEAf8z//CCY8AEUegQCsDDB5EmFDhQoYNHT5ECODfRIoVLV7EmFHjxkeRHn0EGVLkyI0lTZZU5MijopEtXX48GfOkx5c1bd7EmVPnTQsQff4EGtSGqVtFjR49CquIzyuIfGoohFSq0TsOgl7FmlWiTK5dS+4U6VWszEg0wZIcq9HsWbZt3e7smVXuXIdQpyK9FOJnIloUfoq5a3TWE7qFDR/cmlaxWLeLHZsMuVZn2bGS317GfDnuYc5yuwT+vnXHwM8HtG4hAXqD6NRNKDq/xpr48eyYjtrSxo3S9k6uljP/Bo5zM2ziEIdKVRp0SVE/QTeAklpodHHqDmXnxq6R5VmW2b1vjGTbbO/g5c3XRFBdPcM9UhldBVQ01vSfqaKvxx/x+36Ojfn/F8u389gqi6XwVIIpt/wWPMCVqTZoyIqBBprFqD8mjCMNvxaiYaq+FsTvutk+UiQSRQDMSECcIkGxRbVu2g6kskJyJEYXcQMRvx6M6sQSo5xoyIA1QDtqkxMaUqMoWrJowyjUcqxOxMdsupGiGi+rMkstt6QISvXgYI4CAs4oapCHkIiFSNEc+uQWUmIwKIhWbuH+w0vqpHSMNy0x645LP//E0c7iUJkFC4SAUGWWBR4yQZO7YDHiIRVuCWRDgz6oZD5BYcNzsbe4VBEsEwEltdSNNoWNBlBUUAjTpR4yID6kStHroTC6WOiANX5AtbNOFQPOEVIf2S1G7jp6pE8/d3OpLMkcQTBBU8XqtbMZrMoVB5/0kKqVAyDSoK5qD/s1rQGTnZaiZEEy1q0T/wv1XLecNREkaJl9xKtxx21wKh727bXcseRld9R0Mypx3Xm3e3exeAmGWKfhAPZyx6L44MK0W96geFOBGYvYpYO5+uhhKskKOeW2Ju4YxDhuKdQgF9o8pWU7Px5RZRJHzjOkdsn+0zlo4Wz2EpVP4DxoAT5uQZroBXHe78qQedbSZKF1Ztnp6mb4w1KEoChD66d5Vplq/qy+OuWsxSYOwoY4YDtEszHCl+C5HUM77YjXjrtvv627e6aUGw4cPL1tonfGlu5lvCXCMVLgb8knbwjqwi9id/DLN8+Ocs8/H8ByzmW6WtnRT8cIdNX/Fh112hRJOOQaXb97ddvZbp32GxXOWyfYbdOdy9uHJzr34Mlut92bgHapXcWJlTpf1ImnnmLjjw+eWIWlj6n3AZ03C9rtvKu+/Gqvxz59r7w//DLwH0nPfPm9RF+jnIylSWr1R2a/ffP4nl8AiVO/jOgMfyxh1v7jcNM//wUHgAKEILmy00C2xMgs49sfAymYmQdG0INyISBGNig0C9rLdIDS4Ajf0sEPthAoIcScCmXou48gaIEzxJoLdVgYGFoEhz8MDvOASLAatMCIR0RiEpW4RCY20YlPhGIUpThFKl7AcxMcYhb9o0AudtGLXwRjGMU4RjKW0YxnRGMa1bhGNrbRjW+EYxzlOEc61tGOd8RjHvW4Rz720Y9/BGQgBTlIQhbSkIdEZCIVuUhGNtKRj4RkJCU5SUpW0pKXxGQmNblJTnbSk58EZShFOUpSltKUp0RlKlW5SlauMSAAOw==');}</style>
</head>
<body>
<div id='header'>
</div>
<div id='content' style='color: #ffffff; text-align: center;'>
<h2>
The requested resource is currently unavailable
</h2>
<em>request-id: "} + bereq.xid + {"</em>
<div class='euBox'>
<div class='level_1 euItem euNbr_0 euSeqNr_1 euFirst'>
The EUROPA server is temporarily unavailable
<p>We apologise for any inconvenience this may cause you.</p>
</div>
<div class='level_1 euItem euNbr_1 euSeqNr_2 euZebra'>
Serveris EUROPA šobrīd nav pieejams
<p>Mēs atvainojamies par sagādātajām neērtībām.</p>
</div>
<div class='level_1 euItem euNbr_2 euSeqNr_3'>
Поради технически причини нашият сървър временно не работи.
<p>Моля извинете ни за всички евентуални неудобства, причинени от това.</p>
</div>
<div class='level_1 euItem euNbr_3 euSeqNr_4 euZebra'>
EUROPA serveris laikinai neveikia
<p>Atsiprašome dėl nepatogumų.</p>
</div>
<div class='level_1 euItem euNbr_4 euSeqNr_5'>
Server EUROPA je dočasně nedostupný
<p>Omlouváme se za případné nepříjemnosti, které vám tím mohou vzniknout.</p>
</div>
<div class='level_1 euItem euNbr_5 euSeqNr_6 euZebra'>
Szerverünk műszaki okok miatt jelenleg nem elérhető
<p>A kényelmetlenségért elnézést kérünk.</p>
</div>
<div class='level_1 euItem euNbr_6 euSeqNr_7'>
EUROPA-serveren er midlertidigt utilgængelig
<p>Vi beklager.</p>
</div>
<div class='level_1 euItem euNbr_7 euSeqNr_8 euZebra'>
Is-server EUROPA għalissa mhux disponibbli
<p>Niskużaw ruħna għal kull inkonvenjenza li dan jista’ joħloqlok.</p>
</div>
<div class='level_1 euItem euNbr_8 euSeqNr_9'>
Der EUROPA-Server steht zurzeit leider nicht zur Verfügung
<p>Wir bitten um Ihr Verständnis.</p>
</div>
<div class='level_1 euItem euNbr_9 euSeqNr_10 euZebra'>
De Europa server is tijdelijk niet beschikbaar
<p>Onze excuses voor het eventuele ongemak.</p>
</div>
<div class='level_1 euItem euNbr_10 euSeqNr_11'>
EUROPA server on ajutiselt kättesamatu
<p>Vabandame tekkinud ebamugavuste pärast.</p>
</div>
<div class='level_1 euItem euNbr_11 euSeqNr_12 euZebra'>
Serwer EUROPA jest chwilowo niedostępny
<p>Przepraszamy za wszelkie związane z tym niedogodności.</p>
</div>
<div class='level_1 euItem euNbr_12 euSeqNr_13'>
Ο διακομιστής (server) EUROPA είναι προσωρινά μη διαθέσιμος
<p>Ζητάμε συγγνώμη για τυχόν προβλήματα που θα αντιμετωπίσετε.</p>
</div>
<div class='level_1 euItem euNbr_13 euSeqNr_14 euZebra'>
O servidor EUROPA está momentaneamente indisponível
<p>Pedimos desculpa pelo inconveniente.</p>
</div>
<div class='level_1 euItem euNbr_14 euSeqNr_15'>
El servidor EUROPA no funciona por el momento
<p>Disculpe las molestias.</p>
</div>
<div class='level_1 euItem euNbr_15 euSeqNr_16 euZebra'>
Din motive tehnice, serverul nostru este momentan indisponibil
<p>Ne cerem scuze pentru inconvenientele cauzate.</p>
</div>
<div class='level_1 euItem euNbr_16 euSeqNr_17'>
Le serveur EUROPA est temporairement indisponible
<p>Nous sommes désolés de l’inconvénient que cela peut vous causer.</p>
</div>
<div class='level_1 euItem euNbr_17 euSeqNr_18 euZebra'>
Server EUROPA je dočasne nedostupný
<p>Ospravedlňujeme sa za prípadné problémy, ktoré môžu v dôsledku toho vzniknúť.</p>
</div>
<div class='level_1 euItem euNbr_18 euSeqNr_19'>
De bharr cúiseanna teicniúla ní bheidh ár bhfreastalaí ar fáil go ceann tamaill
<p>Is dona linn aon trioblóid a chuirtear ort dá bharr.</p>
</div>
<div class='level_1 euItem euNbr_19 euSeqNr_20 euZebra'>
Strežnik EUROPA je začasno nedosegljiv
<p>Opravičujemo se vam za vse morebitne nevšečnosti.</p>
</div>
<div class='level_1 euItem euNbr_20 euSeqNr_21'>
Poslužitelj EUROPA privremeno je nedostupan
<p>
<span>Ispričavamo se zbog mogućih neugodnosti.</span>
</p>
</div>
<div class='level_1 euItem euNbr_21 euSeqNr_22 euZebra'>
EUROPA-palvelin on väliaikaisesti poissa käytöstä
<p>Pahoittelemme tästä mahdollisesti aiheutuvaa haittaa.</p>
</div>
<div class='level_1 euItem euNbr_22 euSeqNr_23'>
Il server EUROPA è momentaneamente inaccessibile
<p>Ci scusiamo degli inconvenienti che questo le può causare.</p>
</div>
<div class='level_1 euItem euNbr_23 euSeqNr_24 euZebra euLast'>
EUROPA-servern kan för närvarande inte nås
<p>Vi beklagar att detta kan vålla dig problem.</p>
</div>
</div>
</div>
<div id='footer' style='text-align:center;  color: #ffd617;'>
<a href='http://ec.europa.eu/sitemap/index_en.htm' class='first'>Sitemap</a>
|
<a href='http://ec.europa.eu/geninfo/legal_notices_en.htm' accesskey='2'>Legal notice</a>
|
<a href='http://ec.europa.eu/cookies/index_en.htm' accesskey='3'>Cookies</a>
|
<a href='http://ec.europa.eu/contact/index_en.htm' accesskey='4'>Contact</a>
|
<a href='http://ec.europa.eu/geninfo/query/search_en.html' accesskey='5'>Search</a>
</div>
</body></html>
"});
  return(deliver);
}
