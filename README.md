<h1 align="center">Zaig SDK - Ruby</h1>

<h3 align="center">
  # Library to integrate the Zaig services
</h3>

<p align="center">
  <a href="https://github.com/Quasar-Flash/zaig-sdk-ruby/actions/workflows/tests.yml"><img src="https://github.com/Quasar-Flash/zaig-sdk-ruby/actions/workflows/tests.yml/badge.svg" /></a>
  <a href="https://github.com/Quasar-Flash/zaig-sdk-ruby/actions/workflows/release.yml"><img src="https://github.com/Quasar-Flash/zaig-sdk-ruby/actions/workflows/release.yml/badge.svg" /></a>
</p>

## :rocket: Stack

* `ruby 2.7 to 3.1.X`
* `docker`

## :link: Links

* Changelog (please, keep it updated!) - [CHANGELOG.md](CHANGELOG.md).

## 🏃 How to use it

Import the library to your Gemfile:

```ruby
gem "zaig"
```

Initialize the sdk with the basics:

```ruby
Zaig.configure do |config|
  config.access_token = "xxxxx-xxxxx-xxxxx-xxxx" # optional
  config.base_url = "https://example.com"
  config.registration_endpoint = "zaig/consulta_de_credito" # optional
end
```

Run a company registration:

```ruby
args = {} # hash with the company informations
# eg.: spec/fixtures/registration/valid_registration_payload.json
# documentation: https://integra-o-zaig.dev.qflash.com.br/redoc#tag/Zaig
reg_service = Zaig::Registration.instance
res = reg_service.call(args)
# 'res' contains the fields defined at lib/zaig/entities/response.rb
```

## 🏃Preparando para execução

> Clonando repository:

```shell
git clone git@github.com:Quasar-Flash/zaig-sdk-ruby.git
or com htts
git clone https://github.com/Quasar-Flash/zaig-sdk-ruby.git
cd zaig-sdk-ruby/
```

## :train2: Rodando o projeto

Use o docker-compose para instalar e iniciar o sistema localmente, com todas as suas dependências:

```bash
docker-compose down && docker-compose run web bash
```

## :evergreen_tree: Branches

O projeto contém as seguintes _branches_ protegidas:

* [_master_](https://github.com/Quasar-Flash/zaig-sdk-ruby/tree/master) : contém a última versão de [produção](https://qflash.com.br/).
* [_dev_](https://github.com/Quasar-Flash/zaig-sdk-ruby/tree/dev) : contém a última versão do ambiente de [desenvolvimento](https://quasar-flash-staging.herokuapp.com/).
