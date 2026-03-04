# 🚀 Projeto Prospectar Empresas

Sistema web desenvolvido em **Flutter Web** para **prospecção empresarial**, análise de
relacionamento societário e popularização de base de CNPJs através de integrações com APIs backend.

---

## 📌 Objetivo

O sistema permite:

* Consultar empresas por CNPJ
* Visualizar dados cadastrais empresariais
* Analisar sócios e participações em outras empresas
* Identificar possíveis grupos econômicos
* Popular automaticamente uma base de empresas
* Monitorar status de processamento de CNPJs

O foco principal é **auxiliar processos de prospecção comercial e análise empresarial**.

---

## 🧱 Arquitetura Geral

```
Flutter Web (Frontend)
        ↓
API Spring Boot (Backend)
        ↓
MongoDB
```

---

## 🖥️ Funcionalidades do Sistema

### ✅ 1. Prospectar Empresas

Tela principal do sistema.

Permite:

* Listar empresas retornadas pela API
* Filtrar por CNPJ
* Visualizar:

    * Razão social
    * Status da empresa
    * Telefones
    * Emails
    * Sócios
* Expandir sócios para visualizar:

    * Outras empresas que possuem participação
    * Sócios dessas empresas

### Fluxo de navegação

```
Empresa
   → Sócios
       → Empresas relacionadas
           → Sócios relacionados
```

---

### ✅ 2. Popular Base

Processa uma lista de CNPJs automaticamente realizando chamadas sequenciais para a API.

Exibe:

* Total de CNPJs
* Quantos faltam processar
* Status individual:

    * ⏳ Processando
    * ✅ Sucesso
    * ❌ Erro
* Botão de retry individual
* Controle de parada da execução

---

### ⭐ 3. Favoritar Empresas

Permite marcar empresas como favoritas através do botão ⭐.

---

## 🌐 Integrações com API

---

## 🔎 API — Buscar Empresas

Obtém os dados completos das empresas para prospecção.

### Endpoint

```
GET /buscarDadosApi
```

### Responsável

```
BuscarApi.buscarDadosApi()
```

### Retorno (estrutura simplificada)

```json
[
  {
    "dados": [
      {
        "empresa_raiz": "EMPRESA LTDA",
        "cnpj_raiz_id": "00000000000100",
        "status": {
          "text": "ATIVA"
        },
        "telefone": [],
        "email": [],
        "membros": []
      }
    ]
  }
]
```

---

## 🔎 API — Consultar CNPJ

Utilizada na tela **Popular Base** para consultar e inserir empresas na base.

### Endpoint

```
POST /v1/cnpjja/pesquisar_cnpj
```

### Headers

```
Content-Type: application/json
```

### Body

```json
[
  {
    "cnpj": "00000000000100"
  }
]
```

### Respostas esperadas

| Status | Significado            |
|--------|------------------------|
| 200    | Processado com sucesso |
| !=200  | Erro na consulta       |

---

## 🔄 Fluxo de Processamento

```
Lista de CNPJs
      ↓
Processamento sequencial
      ↓
API pesquisar_cnpj
      ↓
Atualização de status na UI
```

---

## 📁 Estrutura do Projeto

```
lib/
│
├── Models/
│   ├── prospectar.dart
│   ├── cnpjStatus.dart
│   └── status.dart
│
├── Views/
│   ├── TelaProspectar.dart
│   └── TelaConsultaCnpjPage.dart
│
├── ModerViews/
│   └── buscarApi.dart
│
├── helpers/
│   └── formatadores.dart
│
└── Widgets/
    └── BotaoFavorito.dart
```

---

## 🎨 Tecnologias Utilizadas

* Flutter Web
* Material Design
* HTTP Package
* Navigator 2.0 (custom transitions)
* Animações Fade + Slide
* Expansão hierárquica dinâmica

---

## 🧠 Conceito de Negócio

O sistema ajuda a identificar:

* conexões societárias
* oportunidades comerciais
* expansão de carteira
* relacionamentos empresariais ocultos

Funciona como uma ferramenta de:

```
Prospecção Inteligente
+ Análise Societária
+ Expansão de Base
```

---

## ▶️ Executando o Projeto

```bash
flutter pub get
flutter run -d chrome
```

---

## ⚙️ Build Produção

```bash
flutter build web
```

---

## 🔐 Observações

* API backend deve estar ativa em:

```
http://localhost:8080
```

* O projeto foi desenvolvido com foco em **Flutter Web Desktop Experience**.

---

## 📈 Melhorias Futuras

* Score automático de prospecção
* Identificação de grupo econômico
* Cache local de consultas
* Execução paralela de CNPJs
* Dashboard analítico

---

## 👨‍💻 Autor

**Marcelo dos Santos**  
Desenvolvedor Flutter • Sistemas • APIs • Integrações

[![GitHub](https://img.shields.io/badge/GitHub-pioriamm-181717?style=for-the-badge&logo=github)](https://github.com/pioriamm/cnpjjaUI)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-pioriam-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/pioriam/)


---
