# 🚌 goSchool — Monitoramento de Transporte Escolar

Aplicativo Flutter para monitoramento em tempo real de crianças no transporte escolar.

---

## 📱 Funcionalidades

### 👨‍👩‍👧 Painel do Responsável
- **Confirmação diária** — toggle para confirmar se o filho vai à escola
- **Rastreamento ao vivo** — mapa Google Maps com posição da van em tempo real
- **ETAs** — horário estimado de chegada na escola e de busca à tarde
- **Status em tempo real** — se o filho está a bordo, com progresso da rota
- **Alertas automáticos** — desvio de rota, embarque, desembarque
- **Notificações** — histórico completo de eventos do dia
- **Histórico** — registro de todas as viagens do mês

### 🚐 Painel do Motorista
- **Cadastro de alunos** — nome, turma, endereço, telefone do responsável
- **Rota otimizada** — geração automática da melhor rota de carro do dia
- **Checklist embarque** — confirmar ✅ ou marcar ausência ❌ de cada aluno
- **Checklist desembarque** — confirmar saída na escola
- **Resumo do dia** — quantos embarcaram, faltaram, pendentes

---

## 🚀 Como rodar

### Pré-requisitos
- Flutter 3.x instalado ([flutter.dev](https://flutter.dev))
- Google Chrome (para Flutter Web)
- Chave da Google Maps API (Maps JavaScript API + Directions API ativadas)

### Passos

**1. Instale as dependências:**
```bash
cd goschool
flutter pub get
```

**2. Configure a chave da API no `web/index.html`:**

Abra `web/index.html` e substitua `MAPS_API_KEY` pela sua chave real:
```html
src="https://maps.googleapis.com/maps/api/js?key=SUA_CHAVE_AQUI&loading=async&callback=initGoSchoolMaps">
```

> ⚠️ O arquivo `web/index.html` está no `.gitignore` para proteger sua chave. Nunca commite a chave real.

**3. Rode o app:**
```bash
flutter run -d chrome
```

### Credenciais demo
| Perfil | E-mail | Senha |
|--------|--------|-------|
| Responsável | responsavel@demo.com | 123456 |
| Motorista | motorista@demo.com | 123456 |

---

## 🔑 Configuração da Google Maps API

### APIs necessárias (ativar no Google Cloud Console)
| API | Para quê |
|-----|----------|
| Maps JavaScript API | Mapa no Flutter Web |
| Directions API | Rota de carro entre paradas |
| Maps SDK for Android | Mapa no Android (futuro) |
| Maps SDK for iOS | Mapa no iOS (futuro) |

### Passos
1. Acesse [console.cloud.google.com](https://console.cloud.google.com)
2. Crie um projeto e vincule uma conta de faturamento (necessário mesmo no plano gratuito — US$200/mês de crédito)
3. Ative as APIs listadas acima em **Biblioteca**
4. Gere a chave em **Credenciais → Criar credencial → Chave de API**

---

## 🔒 Segurança da chave API

O projeto usa `.gitignore` para proteger a chave:

**Arquivos ignorados pelo Git:**
```
web/index.html   ← contém a chave real
.env             ← variáveis de ambiente locais
```

**Fluxo recomendado:**
1. Clone o projeto — `web/index.html` não virá (está no .gitignore)
2. Crie o `web/index.html` localmente com sua chave
3. Nunca faça commit desse arquivo

**Para desativar a chave temporariamente:**
Google Cloud Console → Credenciais → sua chave → **Desativar** (reativar quando precisar apresentar)

---

## 🗄️ Banco de Dados

O app usa **SharedPreferences** para armazenamento local — funciona em Web, Android e iOS sem configuração extra.

Os dados dos alunos ficam salvos entre sessões automaticamente.

### Migração para backend (futuro)
Para conectar ao XAMPP/MySQL, substitua os métodos em `lib/services/database_service.dart` por chamadas HTTP para sua API PHP.

---

## 📁 Estrutura do projeto

```
goschool/
├── .env                              ← chave API local (não vai pro Git)
├── .gitignore
├── pubspec.yaml
├── run.ps1                           ← script Windows para injetar chave
├── web/
│   └── index.html                   ← contém a chave (não vai pro Git)
└── lib/
    ├── main.dart
    ├── theme/
    │   └── app_theme.dart            ← cores e tema global
    ├── models/
    │   └── models.dart               ← Aluno, Notificacao, CheckStatus...
    ├── services/
    │   ├── app_state.dart            ← estado global (Provider)
    │   ├── database_service.dart     ← SharedPreferences
    │   └── directions_service.dart   ← Google Directions via JS interop
    ├── widgets/
    │   └── widgets.dart              ← componentes reutilizáveis
    └── screens/
        ├── login_screen.dart
        ├── responsavel/
        │   ├── responsavel_screen.dart
        │   ├── rastreamento_tab.dart  ← mapa ao vivo + status
        │   ├── notificacoes_tab.dart
        │   └── historico_tab.dart
        └── motorista/
            ├── motorista_screen.dart
            ├── alunos_tab.dart        ← cadastro de alunos
            ├── rota_tab.dart          ← rota otimizada de carro
            └── checklist_tab.dart     ← embarque/desembarque
```

---

## 🔧 Tecnologias

| Pacote | Uso |
|--------|-----|
| `provider` | Gerenciamento de estado |
| `shared_preferences` | Banco de dados local |
| `google_maps_flutter` | Mapa interativo |
| `http` | Chamadas HTTP (Android/iOS) |
| `intl` | Formatação de datas em pt-BR |
| `dart:js` | JS interop para Directions API (Web) |

---

## 📌 Próximos passos para produção

- [ ] Autenticação real (Firebase Auth ou JWT)
- [ ] Backend PHP + MySQL no XAMPP
- [ ] GPS real da van via `geolocator`
- [ ] WebSockets para localização em tempo real
- [ ] Notificações push com Firebase FCM
- [ ] Build para Android e iOS