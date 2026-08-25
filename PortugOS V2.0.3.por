programa
{
  inclua biblioteca Texto --> txt
  inclua biblioteca Util --> u
  inclua biblioteca Matematica --> mat
  inclua biblioteca Calendario --> cal

  // --- BANCO DE DADOS DE USUÁRIOS ---
  cadeia banco_usuarios[10] = {"admin", "", "", "", "", "", "", "", "", ""}
  cadeia banco_senhas[10]   = {"1234", "", "", "", "", "", "", "", "", ""}
  logico eh_admin[10]       = {verdadeiro, falso, falso, falso, falso, falso, falso, falso, falso, falso}
  inteiro total_usuarios = 1
  cadeia usuario_logado = "" 

  // --- SISTEMA DE ARQUIVOS VIRTUAL ---
  cadeia nomes_arquivos[20]
  cadeia conteudos_arquivos[20]
  cadeia donos_arquivos[20]
  logico eh_zip[20]            
  cadeia senhas_arquivos[20]   
  inteiro total_arquivos = 0

  // --- AGENDA DE CONTATOS ---
  cadeia agenda_nomes[20]
  cadeia agenda_fones[20]
  cadeia agenda_donos[20]
  inteiro total_contatos = 0

  // --- COFRE DE SENHAS ---
  cadeia cofre_servicos[20]
  cadeia cofre_senhas_salvas[20]
  cadeia cofre_donos[20]
  inteiro total_cofre = 0

  // --- SISTEMA DE WI-FI ---
  logico wifi_conectado = falso
  cadeia rede_atual = ""
  cadeia redes_disponiveis[4] = {"PortugOS_Net", "Gato_Net", "Fibra_Rapida", "Cafe_Free"}
  cadeia senhas_wifi[4] = {"portugaSO12345", "SrBolasdePelo6767", "velocidade1239002veloz", ""}
  

  // --- BANCO DE DADOS DE JOGOS E CHEATS ---
  cadeia forca_palavras[20] = {
      "COMPUTADOR", "PORTUGOL", "PROGRAMADOR", "TECLADO", "ALGORITMO",
      "MOUSE", "MONITOR", "INTERNET", "SISTEMA", "SOFTWARE",
      "HARDWARE", "PROCESSADOR", "MEMORIA", "PLACA", "VIDEO",
      "REDE", "SERVIDOR", "ARQUIVO", "PASTA", "HACKER"
  }
  logico cheat_forca = falso
  logico cheat_quiz = falso

  cadeia quiz_perguntas[200]
  cadeia quiz_opcoes[200][3]
  inteiro quiz_gabarito[200]
  inteiro total_bd_quiz = 0

  // --- MEMÓRIA DO VISUAL SHIDO CODES ---
  cadeia vsc_var_nomes[50]
  cadeia vsc_var_tipos[50]
  cadeia vsc_var_valores[50]
  inteiro vsc_total_vars = 0
  
// --- SISTEMA DE LEMBRETES DO CALENDÁRIO ---
  cadeia lembretes_textos[20]
  inteiro lembretes_dias[20]
  inteiro lembretes_meses[20]
  inteiro total_lembretes = 0

funcao logico tela_boot()
{
  inteiro opcao_boot

  enquanto (verdadeiro)
  {
    limpa()
    escreva("====================================\n")
    escreva("         BIOS - PortugOS            \n")
    escreva("====================================\n\n")
    escreva(" [1] Iniciar PortugOS normalmente\n")
    escreva(" [2] Desligar o sistema\n\n")
    escreva("Escolha uma opção: ")
    leia(opcao_boot)

    se (opcao_boot == 1)
    {
      escreva("\nCarregando componentes...\n")
      u.aguarde(1500) // Efeito de carregamento
      retorne verdadeiro // Sinaliza para ir ao login
    }
    senao se (opcao_boot == 2)
    {
      escreva("\nDesligando a máquina...\n")
      u.aguarde(1000)
      retorne falso // Sinaliza para encerrar
    }
    senao
    {
      escreva("\nOpção inválida!\n")
      u.aguarde(1000)
    }
  }
  retorne falso
}
  
  funcao inicio()
  {
    // 1. Chama o menu de boot primeiro
    logico iniciar_sistema = tela_boot()

    // 2. Verifica se o usuário apertou 1 (iniciar_sistema será verdadeiro)
    se (iniciar_sistema == verdadeiro)
    {
      // --- SEU SISTEMA OPERACIONAL COMEÇA AQUI ---
      carregar_banco_quiz() 

      inteiro status_sistema = 1 

      para (inteiro i = 0; i < 20; i++) { 
        eh_zip[i] = falso 
        senhas_arquivos[i] = "" 
      }

      enquanto (status_sistema == 1 ou status_sistema == 2)
      {
        se (status_sistema == 2)
        {
          limpa()
          escreva("\n[ PortugOS Reiniciando... ]\n")
          u.aguarde(1500)
          escreva("Descarregando memória...\n")
          u.aguarde(1000)
          escreva("Carregando módulos do núcleo...\n")
          u.aguarde(1500)
          limpa()
          status_sistema = 1 
        }

        se (fazer_login()) 
        {
          status_sistema = executar_terminal() 
        }
        senao 
        {
          escreva("\nSistema bloqueado por excesso de tentativas.\n")
          status_sistema = 0 
        }
      }
      // --- FIM DO SEU SISTEMA OPERACIONAL ---
    }
    senao
    {
      // Cai aqui se apertar 2 na tela de boot
      escreva("\nOperação cancelada pelo usuário na BIOS.\n")
    }
    
    escreva("\n[ PortugOS Desligado ]\n")
  }
  funcao inteiro obter_indice_usuario(cadeia nome)
  {
    para (inteiro i = 0; i < total_usuarios; i++)
    {
      se (banco_usuarios[i] == nome) { retorne i }
    }
    retorne -1
  }

  funcao logico fazer_login()
  {
    cadeia user, pass
    inteiro tentativas = 0
    logico sucesso_login = falso

    enquanto (tentativas < 3)
    {
      limpa()
      escreva("====================================\n")
      escreva("          PortugOS LOGIN            \n")
      escreva("====================================\n")
      
      escreva("USUÁRIO: ")
      leia(user)
      escreva("SENHA: ")
      leia(pass)

      para (inteiro i = 0; i < total_usuarios; i++)
      {
        se (user == banco_usuarios[i] e pass == banco_senhas[i])
        {
          usuario_logado = user
          sucesso_login = verdadeiro
          pare
        }
      }

      se (sucesso_login)
      {
        escreva("\nAutenticando...")
        u.aguarde(5000)
        limpa()
        retorne verdadeiro
      }
      senao
      {
        tentativas++
        escreva("\nLogin incorreto! Tentativas restantes: ", 3 - tentativas)
        u.aguarde(2000)
      }
    }
    retorne falso
  }

  

  funcao inteiro executar_terminal()
  {
    cadeia comando = ""
    cadeia cmd_upper = ""
    
    escreva("PortugOS [Versão 2.0.1 - Sistema Operacional Avançado dentro do Portugol Webstudio]\n")
    escreva("====================================================================================== \n")
    escreva("Olá, ", usuario_logado, "! Pronto para comandos.\n\n") 

    enquanto(cmd_upper != "SAIR" e cmd_upper != "DESLIGAR" e cmd_upper != "REINICIAR")
    {
      escreva("C:\\> ")
      leia(comando)
      cmd_upper = txt.caixa_alta(comando) 

      se (txt.posicao_texto("CRACK DEATH INTERNET -1.3.8.9.0.0.2:", cmd_upper, 0) == 0)
      {
        logico achou_rede = falso
        inteiro indice_alvo = -1

        para (inteiro i = 0; i < 4; i++) {
          se (txt.posicao_texto(txt.caixa_alta(redes_disponiveis[i]), cmd_upper, 0) >= 0) {
            indice_alvo = i
            achou_rede = verdadeiro
            pare
          }
        }

        se (achou_rede) {
          escreva("\n[!] INTERCEPTANDO PACOTES DA REDE: ", redes_disponiveis[indice_alvo], "...\n")
          u.aguarde(1500)
          escreva("[FIREWALL DETECTADO] Bloqueio de segurança ativo!\n")
          
          escreva("\nAnalisando matriz de pacotes binários...\n")
          para (inteiro linha = 0; linha < 6; linha++) {
            para (inteiro col = 0; col < 8; col++) {
               escreva(u.sorteia(0, 1), u.sorteia(0, 1), u.sorteia(0, 1), u.sorteia(0, 1), " ")
            }
            escreva("\n")
            u.aguarde(400)
          }

          escreva("\nCriptografia convertida. A rede exige uma chave alfanumérica estendida.\n")
          escreva("Copie a sequência exata de letras e números para quebrar a segurança.\n")

          cadeia charset[36] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"}
          cadeia chave_gerada = ""
          
          para (inteiro c = 0; c < 16; c++) {
            chave_gerada = chave_gerada + charset[u.sorteia(0, 35)]
          }
          
          inteiro tentativas_hack = 0
          logico hack_sucesso = falso
          cadeia resposta_hack

          enquanto (tentativas_hack < 3 e hack_sucesso == falso) {
            escreva("\n>> CHAVE CRIPTOGRÁFICA INTERCEPTADA:\n[ ", chave_gerada, " ]\n")
            escreva("Digite a chave para descriptografar (Tentativa ", tentativas_hack + 1, "/3): ")
            leia(resposta_hack)

            se (txt.caixa_alta(resposta_hack) == chave_gerada) {
              hack_sucesso = verdadeiro
            }
            senao {
              tentativas_hack++
              escreva("\n[X] ACESSO NEGADO! Chave incorreta.\n")
            }
          }

          se (hack_sucesso) {
            escreva("\n>> ACESSO CONCEDIDO - FIREWALL BYPASSADO <<\n")
            u.aguarde(1000)
            escreva("Rede Alvo: ", redes_disponiveis[indice_alvo], "\n")
            escreva("Endereço IP: 192.168.", u.sorteia(1, 254), ".", u.sorteia(1, 254), "\n")
            se (senhas_wifi[indice_alvo] == "") { escreva("Senha Decriptada: [ REDE ABERTA / SEM SENHA ]\n\n") }
            senao { escreva("Senha Decriptada: ", senhas_wifi[indice_alvo], "\n\n") }
          }
          senao {
            escreva("\n=============================================\n")
            escreva(" [!] ALERTA CRÍTICO DE SEGURANÇA [!]\n")
            escreva(" INVASÃO DETECTADA. BLOQUEANDO COMPUTADOR...\n")
            escreva("=============================================\n")
            u.aguarde(3000)
            retorne 0 
          }
        }
        senao {
          escreva("\n[ERRO] Rede não identificada ou fora de alcance.\n\n")
        }
      }
      
      senao se (txt.posicao_texto("CRACK DEATH USER:", cmd_upper, 0) == 0)
      {
        logico achou_user_alvo = falso
        inteiro indice_user_alvo = -1
        cadeia nome_alvo_real = ""

        para (inteiro i = 0; i < total_usuarios; i++) {
          se (txt.posicao_texto(txt.caixa_alta(banco_usuarios[i]), cmd_upper, 16) >= 0 e banco_usuarios[i] != "") {
            indice_user_alvo = i
            achou_user_alvo = verdadeiro
            nome_alvo_real = banco_usuarios[i]
            pare
          }
        }

        se (achou_user_alvo) {
          se (txt.caixa_alta(nome_alvo_real) == txt.caixa_alta(usuario_logado)) {
            escreva("\n[ERRO] Você não pode hackear a si mesmo!\n\n")
          } senao {
            escreva("\n[!] INICIANDO INVASÃO NO DIRETÓRIO DE: ", txt.caixa_alta(nome_alvo_real), "...\n")
            u.aguarde(1500)
            escreva("[FIREWALL DE USUÁRIO DETECTADO] Bloqueio de disco ativo!\n")
            
            escreva("\nAnalisando matriz de permissões root...\n")
            para (inteiro linha = 0; linha < 6; linha++) {
              para (inteiro col = 0; col < 8; col++) {
                 escreva(u.sorteia(0, 1), u.sorteia(0, 1), u.sorteia(0, 1), u.sorteia(0, 1), " ")
              }
              escreva("\n")
              u.aguarde(400)
            }

            escreva("\nCriptografia de disco encontrada. Quebre a chave para revelar os arquivos.\n")

            cadeia charset_u[36] = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9"}
            cadeia chave_gerada_u = ""
            
            para (inteiro c = 0; c < 16; c++) {
              chave_gerada_u = chave_gerada_u + charset_u[u.sorteia(0, 35)]
            }
            
            inteiro tentativas_hack_u = 0
            logico hack_sucesso_u = falso
            cadeia resposta_hack_u

            enquanto (tentativas_hack_u < 3 e hack_sucesso_u == falso) {
              escreva("\n>> CHAVE DE DISCO INTERCEPTADA:\n[ ", chave_gerada_u, " ]\n")
              escreva("Digite a chave exata para invasão (Tentativa ", tentativas_hack_u + 1, "/3): ")
              leia(resposta_hack_u)

              se (txt.caixa_alta(resposta_hack_u) == chave_gerada_u) {
                hack_sucesso_u = verdadeiro
              }
              senao {
                tentativas_hack_u++
                escreva("\n[X] ACESSO NEGADO! Chave incorreta.\n")
              }
            }

            se (hack_sucesso_u) {
              escreva("\n>> INVASÃO BEM-SUCEDIDA - ACESSO ROOT CONCEDIDO <<\n")
              u.aguarde(1000)
              escreva("\n=============================================\n")
              escreva(" VAZAMENTO DE ARQUIVOS DE: ", txt.caixa_alta(nome_alvo_real), "\n")
              escreva("=============================================\n")
              
              inteiro arquivos_achados = 0
              para (inteiro i = 0; i < total_arquivos; i++) {
                se (donos_arquivos[i] == nome_alvo_real) {
                  arquivos_achados++
                  se (eh_zip[i]) {
                    escreva("\n[ARQUIVO PROTEGIDO ZIP] ", nomes_arquivos[i], ".ZIP\n")
                    se (senhas_arquivos[i] != "") {
                      escreva(" -> Senha Extraída: [ ", senhas_arquivos[i], " ]\n")
                    } senao {
                      escreva(" -> Senha: [ SEM SENHA ]\n")
                    }
                  } senao {
                    escreva("\n[ARQUIVO DE TEXTO] ", nomes_arquivos[i], ".TXT\n")
                    escreva(" -> Conteúdo: \"", conteudos_arquivos[i], "\"\n")
                  }
                }
              }

              se (arquivos_achados == 0) {
                escreva("\n O usuário não possui nenhum arquivo salvo no momento.\n")
              }
              escreva("=============================================\n\n")
            }
            senao {
              escreva("\n=============================================\n")
              escreva(" [!] ALERTA CRÍTICO DE SEGURANÇA [!]\n")
              escreva(" INVASÃO DE PRIVACIDADE DETECTADA. BLOQUEANDO...\n")
              escreva("=============================================\n")
              u.aguarde(3000)
              retorne 0 
            }
          }
        } senao {
          escreva("\n[ERRO] Usuário alvo não encontrado no sistema. Tem certeza do nome?\n\n")
        }
      }

      senao se (txt.posicao_texto("CHEAT GAME", cmd_upper, 0) >= 0)
      {
        se (txt.posicao_texto("FORCA", cmd_upper, 0) >= 0) {
          cheat_forca = verdadeiro
          escreva("\n[CHEAT ATIVADO] As palavras possíveis da Forca são:\n")
          para(inteiro i=0; i<20; i++) { escreva(forca_palavras[i], " | ") }
          escreva("\nUma dica aparecerá na tela do jogo!\n\n")
        }
        senao se (txt.posicao_texto("QUIZ", cmd_upper, 0) >= 0) {
          cheat_quiz = verdadeiro
          escreva("\n[CHEAT ATIVADO] Módulo de injeção cerebral ativado.\n")
          escreva("O gabarito será exibido ao lado das opções dentro do Quiz!\n\n")
        }
        senao {
          escreva("\n[ERRO] Jogo não suporta injeção de código ou nome incorreto. Tente: CHEAT GAME FORCA ou CHEAT GAME QUIZ.\n\n")
        }
      }
      senao se (cmd_upper == "GOD ADMIN USER 0.3.2.9.1.2.6")
      {
        para (inteiro i = 0; i < total_usuarios; i++) {
          eh_admin[i] = verdadeiro
        }
        escreva("\n[GOD MODE] Modificação no Kernel bem-sucedida.\n")
        escreva("Todos os usuários registrados agora possuem privilégios de ADMINISTRADOR!\n\n")
      }
      senao se (txt.posicao_texto("HELP", cmd_upper, 0) == 0 ou txt.posicao_texto("AJUDA", cmd_upper, 0) == 0)
      {
        se (txt.posicao_texto("APPS", cmd_upper, 0) > 0 ou txt.posicao_texto("APLICATIVOS", cmd_upper, 0) > 0) {
          escreva("\n[HELP: APPS]\n- Use para abrir programas de produtividade.\n- Ferramentas: Arquivos, PortuZIP, Calculadora, Agenda, Cofre, Cronômetro, Gráficos e Visual Shido Codes.\n\n")
        }
        senao se (txt.posicao_texto("JOGOS", cmd_upper, 0) > 0) {
          escreva("\n[HELP: JOGOS]\n- Centro de entretenimento do PortugOS.\n- Possui Forca, Jogo da Velha, Par ou Ímpar e um Quiz de TI.\n\n")
        }
        senao se (txt.posicao_texto("CONFIG", cmd_upper, 0) > 0) {
          escreva("\n[HELP: CONFIGURAÇÕES]\n- Central de controle. Permite mudar nome/senha e contas.\n\n")
        }
        senao se (txt.posicao_texto("WIFI", cmd_upper, 0) > 0) {
          escreva("\n[HELP: WIFI]\n- Conecta o SO à internet.\n\n")
        }
        senao {
          escreva("\n[HELP GERAL]\nComandos básicos: VER, CLEAR, DIR, APPS, JOGOS, CONFIG, CREDITOS, LOGOUT, REINICIAR, SAIR.\n")
          escreva("Para ajuda detalhada, digite: HELP APPS, HELP JOGOS, HELP CONFIG, HELP WIFI\n\n")
        }
      }
      senao
      {
        escolha(cmd_upper)
        {
          caso "BATATA":
            escreva("\n====================================\n")
            escreva("Oh, doce batata de casca dourada,\n")
            escreva("És a raiz que mais amo, minha eterna namorada.\n")
            escreva("Seja frita, assada ou em um suave purê,\n")
            escreva("Meu sistema operacional só funciona com você.\n")
            escreva("Neste terminal frio, de zeros e um,\n")
            escreva("Você é meu carboidrato, não há outro comum.\n")
            escreva("Aceite, minha batata, esta humilde canção,\n")
            escreva("Pois você hackeou o meu coração!\n")
            escreva("====================================\n\n")
            pare
          caso "VER": escreva("PortugOS Versão 2.0.1 - Núcleo Portugol\n\n") pare
          caso "CLEAR":
          caso "LIMPAR": limpa() pare
          caso "DIR":
            escreva(" Listando C:\\USUARIOS\\", txt.caixa_alta(usuario_logado), "\\\n")
            escreva(" [SISTEMA]     <DIR>\n")
            para (inteiro i = 0; i < total_arquivos; i++) {
              se (donos_arquivos[i] == usuario_logado) {
                 se (eh_zip[i]) {
                    escreva(" ", txt.caixa_alta(nomes_arquivos[i]), ".ZIP     [ARQUIVO COMPACTADO]\n")
                 } senao {
                    escreva(" ", txt.caixa_alta(nomes_arquivos[i]), ".TXT     ", txt.numero_caracteres(conteudos_arquivos[i]), " bytes\n")
                 }
              }
            }
            escreva("\n") pare
          caso "APP":
          caso "APPS":
          caso "APLICATIVOS":
            abrir_aplicativos() escreva("Você fechou os aplicativos.\n\n") pare
          caso "JOGO":
          caso "JOGOS":
            abrir_jogos() escreva("Você saiu do Fliperama PortugOS.\n\n") pare
          caso "CONFIGURACOES":
          caso "CONFIGURAÇÕES":
          caso "CONFIG":
            inteiro acao_config = abrir_configuracoes()
            se (acao_config == 1) { retorne 1 }
            senao se (acao_config == 2) { retorne 2 }
            senao { escreva("Você voltou ao terminal principal.\n\n") } pare
          caso "CREDITOS":
          caso "CRÉDITOS":
            escreva("\n====================================\n        CRÉDITOS DO SISTEMA         \n====================================\n Desenvolvedor e Criador: Cauê Shishido\n Assistente de IA: Gemini\n====================================\n\n") pare
          caso "LOGOUT":
            escreva("Encerrando a sessão de '", usuario_logado, "'...\n") u.aguarde(1000) retorne 1 
          caso "REINICIAR":
            escreva("Preparando para reiniciar o sistema...\n") u.aguarde(1000) retorne 2
          caso "SAIR":
          caso "DESLIGAR":
            escreva("Desligando o PortugOS...\n") u.aguarde(1000) limpa() retorne 0 
          caso contrario:
            se (cmd_upper != "") {
              escreva("Comando '", cmd_upper, "' desconhecido.\n")
              escreva("Tente: HELP, APPS, JOGOS, CONFIG, DIR, CLEAR, CREDITOS, LOGOUT, REINICIAR ou DESLIGAR.\n\n")
            }
        }
      }
    }
    retorne 0
  }

  funcao abrir_aplicativos()
{
  inteiro opcao_app = 0
  enquanto (opcao_app != 12) // Alterado para 12 para fechar
  {
    limpa()
    escreva("====================================\n")
    escreva("         APPS DO SISTEMA            \n")
    escreva("====================================\n")
    escreva("  1. Bloco de Notas Avançado\n")
    escreva("  2. Lixeira Geral (Excluir ZIPs/Outros)\n")
    escreva("  3. PortuZIP (Compactar/Extrair)\n")
    escreva("  4. Calculadora Super Avançada\n")
    escreva("  5. Agenda de Contatos\n")
    escreva("  6. Cofre de Senhas\n")
    escreva("  7. Cronômetro\n")
    escreva("  8. Criador de Gráficos ASCII\n")
    escreva("  9. Visual Shido Codes (IDE)\n")
    escreva(" 10. Calendário do Sistema\n")
    escreva(" 11. PortuPoint (Criador de Slides)\n") // NOVA OPÇÃO
    escreva(" 12. Voltar ao Terminal\n")
    escreva("====================================\nEscolha uma opção: ")
    leia(opcao_app)

    escolha(opcao_app) {
      caso 1: app_bloco_avancado() pare
      caso 2: app_excluir_arquivo() pare
      caso 3: app_portuzip() pare
      caso 4: app_calculadora() pare
      caso 5: app_agenda() pare
      caso 6: app_cofre() pare
      caso 7: app_cronometro() pare
      caso 8: app_gerador_graficos() pare 
      caso 9: app_visual_shido_codes() pare 
      caso 10: app_calendario() pare
      caso 11: app_slides() pare // CHAMADA DO NOVO APP
      caso 12: escreva("\nFechando aplicativos...\n") u.aguarde(800) limpa() pare
      caso contrario: escreva("\nOpção inválida!\n") u.aguarde(1500)
    }
  }
}

funcao app_slides()
{
  inteiro op_sld = 0
  cadeia pausa

  enquanto (op_sld != 4)
  {
    limpa()
    escreva("====================================\n")
    escreva("    PORTUPOINT - APRESENTAÇÕES      \n")
    escreva("====================================\n")
    escreva("  1. Criar Nova Apresentação (.sld)\n")
    escreva("  2. Modo Apresentação (Assistir)\n")
    escreva("  3. Excluir Apresentação\n")
    escreva("  4. Voltar ao Menu\n")
    escreva("====================================\nEscolha: ")
    leia(op_sld)

    // --- CRIAR SLIDES ---
    se (op_sld == 1)
    {
      se (total_arquivos < 20) {
        cadeia nome_apres, conteudo_full = "", texto_slide = ""
        inteiro num_slides
        
        escreva("\nNome da apresentação (sem .sld): ")
        leia(nome_apres)
        escreva("Quantos slides terá sua apresentação? ")
        leia(num_slides)

        para (inteiro s = 1; s <= num_slides; s++) {
          limpa()
          escreva("--- EDITANDO SLIDE ", s, " / ", num_slides, " ---\n")
          escreva("Digite o conteúdo do slide (use apenas uma linha):\n> ")
          leia(texto_slide)
          // Usamos o '@' como separador de páginas interno
          conteudo_full = conteudo_full + texto_slide + "@"
        }

        nomes_arquivos[total_arquivos] = nome_apres + ".sld"
        conteudos_arquivos[total_arquivos] = conteudo_full
        donos_arquivos[total_arquivos] = usuario_logado
        eh_zip[total_arquivos] = falso
        total_arquivos++
        
        escreva("\n[OK] Apresentação '", nome_apres, ".sld' salva!\n")
        u.aguarde(1500)
      } senao {
        escreva("\n[ERRO] Memória cheia!\n")
        u.aguarde(1500)
      }
    }
    // --- MODO APRESENTAÇÃO ---
    senao se (op_sld == 2)
    {
      limpa()
      escreva("--- SELECIONE A APRESENTAÇÃO ---\n")
      inteiro achou_sld = 0
      para (inteiro i = 0; i < total_arquivos; i++) {
        se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".sld", nomes_arquivos[i], 0) != -1) {
          escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
          achou_sld++
        }
      }

      se (achou_sld == 0) {
        escreva("\nNenhuma apresentação encontrada.\n")
        u.aguarde(1500)
      } senao {
        inteiro id_sld
        escreva("\nID da apresentação para iniciar: ")
        leia(id_sld)

        se (id_sld >= 0 e id_sld < total_arquivos e donos_arquivos[id_sld] == usuario_logado) {
          cadeia arquivo_bruto = conteudos_arquivos[id_sld]
          inteiro total_caracteres = txt.numero_caracteres(arquivo_bruto)
          cadeia slide_atual = ""
          inteiro pag = 1

          limpa()
          escreva("Iniciando: ", nomes_arquivos[id_sld], "...\n")
          u.aguarde(1000)

          // Lógica para ler caractere por caractere e limpar a tela no '@'
          para (inteiro c = 0; c < total_caracteres; c++) {
            cadeia char = txt.extrair_subtexto(arquivo_bruto, c, c + 1)
            
            se (char == "@") {
              limpa()
              escreva("==========================================\n")
              escreva("  PÁGINA: ", pag, "\n")
              escreva("==========================================\n\n")
              escreva("  ", slide_atual, "\n\n")
              escreva("==========================================\n")
              escreva("Pressione ENTER para o próximo slide...")
              leia(pausa)
              slide_atual = ""
              pag++
              limpa()
            } senao {
              slide_atual = slide_atual + char
            }
          }
          escreva("\n--- Fim da Apresentação ---\n")
          u.aguarde(1500)
        } senao {
          escreva("\n[ERRO] ID Inválido!\n")
          u.aguarde(1500)
        }
      }
    }
    // --- EXCLUIR SLIDES ---
    senao se (op_sld == 3)
    {
      limpa()
      escreva("--- EXCLUIR APRESENTAÇÃO ---\n")
      inteiro achou_del = 0
      para (inteiro i = 0; i < total_arquivos; i++) {
        se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".sld", nomes_arquivos[i], 0) != -1) {
          escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
          achou_del++
        }
      }
      
      se (achou_del > 0) {
        inteiro id_del
        escreva("\nID para excluir (ou -1): ")
        leia(id_del)
        se (id_del >= 0 e id_del < total_arquivos e donos_arquivos[id_del] == usuario_logado) {
           para (inteiro j = id_del; j < total_arquivos - 1; j++) {
             nomes_arquivos[j] = nomes_arquivos[j+1]
             conteudos_arquivos[j] = conteudos_arquivos[j+1]
             donos_arquivos[j] = donos_arquivos[j+1]
           }
           total_arquivos--
           escreva("\n[+] Removido com sucesso!\n")
        }
      } senao {
        escreva("Nada para excluir.\n")
      }
      u.aguarde(1500)
    }
  }
}
  
funcao app_calendario()
  {
    inteiro op_cal = 0
    cadeia pausa

    enquanto (op_cal != 6) 
    {
      limpa()
      escreva("====================================\n")
      escreva("       CALENDÁRIO PORTUGOS          \n")
      escreva("====================================\n")
      escreva("  1. Ver Data e Hora Atual do Sistema\n")
      escreva("  2. Ver Painel do Mês\n")
      escreva("  3. Adicionar Lembrete\n")
      escreva("  4. Ver Meus Lembretes\n")
      escreva("  5. Excluir Lembrete\n") 
      escreva("  6. Fechar Calendário\n")
      escreva("====================================\nEscolha: ")
      leia(op_cal)

      se (op_cal == 1)
      {
        inteiro d = cal.dia_mes_atual()
        inteiro m = cal.mes_atual()
        inteiro a = cal.ano_atual()
        inteiro hora = cal.hora_atual(falso)
        inteiro min = cal.minuto_atual()
        
        escreva("\n[ RELÓGIO DO SISTEMA ]\n")
        escreva("-> Data de Hoje: ", d, "/", m, "/", a, "\n")
        
        escreva("-> Horário Local: ")
        se (hora < 10) { escreva("0") }
        escreva(hora, ":")
        se (min < 10) { escreva("0") }
        escreva(min, "\n\n")
        
        escreva("Pressione ENTER para voltar...")
        leia(pausa)
      }
      senao se (op_cal == 2)
      {
        inteiro m = cal.mes_atual()
        cadeia nome_mes = ""
        
        escolha(m) {
          caso 1: nome_mes = "JANEIRO" pare
          caso 2: nome_mes = "FEVEREIRO" pare
          caso 3: nome_mes = "MARÇO" pare
          caso 4: nome_mes = "ABRIL" pare
          caso 5: nome_mes = "MAIO" pare
          caso 6: nome_mes = "JUNHO" pare
          caso 7: nome_mes = "JULHO" pare
          caso 8: nome_mes = "AGOSTO" pare
          caso 9: nome_mes = "SETEMBRO" pare
          caso 10: nome_mes = "OUTUBRO" pare
          caso 11: nome_mes = "NOVEMBRO" pare
          caso 12: nome_mes = "DEZEMBRO" pare
        }

        escreva("\n--- MÊS DE ", nome_mes, " ---\n")
        escreva(" DOM SEG TER QUA QUI SEX SAB\n")
        escreva("   1   2   3   4   5   6   7\n")
        escreva("   8   9  10  11  12  13  14\n")
        escreva("  15  16  17  18  19  20  21\n")
        escreva("  22  23  24  25  26  27  28\n")
        escreva("  29  30  31\n\n")
        escreva("Pressione ENTER para voltar...")
        leia(pausa)
      }
      // --- LÓGICA DE ADICIONAR LEMBRETE CORRIGIDA ---
      senao se (op_cal == 3)
      {
        se (total_lembretes < 20) 
        {
          inteiro m = 0, d = 0
          
          // --- VALIDAÇÃO DO MÊS ---
          faca {
            limpa()
            escreva("\n[ NOVO LEMBRETE ]\n")
            // Se m for diferente de 0, é porque ele já digitou um número inválido antes
            se (m != 0) { escreva(" -> Mês inválido! Tente novamente.\n\n") }
            escreva("Qual o mês? (1 a 12): ")
            leia(m)
          } enquanto (m < 1 ou m > 12)

          // --- DEFINE O LIMITE DE DIAS DO MÊS ESCOLHIDO ---
          inteiro max_dias = 31
          se (m == 4 ou m == 6 ou m == 9 ou m == 11) { max_dias = 30 }
          senao se (m == 2) { max_dias = 29 } 

          // --- VALIDAÇÃO DO DIA ---
          faca {
            limpa()
            escreva("\n[ NOVO LEMBRETE ]\n")
            escreva("Mês escolhido: ", m, "\n")
            se (d != 0) { escreva(" -> Dia inválido para o mês ", m, "! Tente novamente.\n\n") }
            senao { escreva("\n") }
            escreva("Qual o dia do lembrete? (1 a ", max_dias, "): ")
            leia(d)
          } enquanto (d < 1 ou d > max_dias)
          
          lembretes_meses[total_lembretes] = m
          lembretes_dias[total_lembretes] = d

          // --- DIGITAR O AVISO ---
          limpa()
          escreva("\n[ NOVO LEMBRETE ]\n")
          escreva("Data escolhida: ")
          se (d < 10) { escreva("0") }
          escreva(d, "/")
          se (m < 10) { escreva("0") }
          escreva(m, "\n\n")

          escreva("Digite o aviso/lembrete: ")
          leia(lembretes_textos[total_lembretes])
          
          total_lembretes++
          escreva("\nLembrete agendado com sucesso!\n")
        }
        senao 
        {
          escreva("\nA memória de lembretes está cheia!\n")
        }
        u.aguarde(1500)
      }
      senao se (op_cal == 4)
      {
        escreva("\n--- MEUS LEMBRETES AGENDADOS ---\n")
        
        se (total_lembretes == 0) 
        {
          escreva("Nenhum lembrete na agenda.\n")
        }
        senao 
        {
          para (inteiro i = 0; i < total_lembretes; i++) 
          {
            se (lembretes_dias[i] < 10) { escreva("0") }
            escreva(lembretes_dias[i], "/")
            se (lembretes_meses[i] < 10) { escreva("0") }
            escreva(lembretes_meses[i], " -> ", lembretes_textos[i], "\n")
          }
        }
        escreva("\nPressione ENTER para voltar...")
        leia(pausa)
      }
      senao se (op_cal == 5)
      {
        escreva("\n--- EXCLUIR LEMBRETE ---\n")
        
        se (total_lembretes == 0) 
        {
          escreva("Nenhum lembrete salvo para excluir.\n")
        }
        senao 
        {
          para (inteiro i = 0; i < total_lembretes; i++) 
          {
            escreva(" [", i, "] - ")
            se (lembretes_dias[i] < 10) { escreva("0") }
            escreva(lembretes_dias[i], "/")
            se (lembretes_meses[i] < 10) { escreva("0") }
            escreva(lembretes_meses[i], " -> ", lembretes_textos[i], "\n")
          }
          
          inteiro id_excluir
          escreva("\nDigite o número entre chaves [ ] para excluir (ou -1 para cancelar): ")
          leia(id_excluir)

          se (id_excluir >= 0 e id_excluir < total_lembretes) 
          {
            para (inteiro i = id_excluir; i < total_lembretes - 1; i++) 
            {
              lembretes_dias[i] = lembretes_dias[i+1]
              lembretes_meses[i] = lembretes_meses[i+1]
              lembretes_textos[i] = lembretes_textos[i+1]
            }
            
            lembretes_dias[total_lembretes - 1] = 0
            lembretes_meses[total_lembretes - 1] = 0
            lembretes_textos[total_lembretes - 1] = ""
            
            total_lembretes--
            escreva("\nLembrete excluído com sucesso!\n")
          } 
          senao se (id_excluir != -1) 
          {
            escreva("\nNúmero de lembrete inválido!\n")
          }
        }
        u.aguarde(2000)
      }
      senao se (op_cal != 6)
      {
        escreva("\nOpção Inválida!\n")
        u.aguarde(1500)
      }
    }
  }

  // === VISUAL SHIDO CODES (IDE) APRIMORADO ===

funcao app_visual_shido_codes()
  {
    inteiro op_ide = 0
    cadeia pausa

    enquanto (op_ide != 4)
    {
      limpa()
      escreva("====================================\n")
      escreva("    VISUAL SHIDO CODES (Beta V 0.0.5)        \n")
      escreva("====================================\n")
      escreva("  1. Criar Novo Código (.por)\n")
      escreva("  2. Visualizar Código\n")
      escreva("  3. Compilar e Testar Código\n")
      escreva("  4. Fechar Visual Shido\n")
      escreva("====================================\nEscolha: ")
      leia(op_ide)

      se (op_ide == 1)
      {
        se (total_arquivos < 20)
        {
          cadeia nome_arquivo, codigo, linha
          escreva("\nNome do seu programa (sem .por): ")
          leia(nome_arquivo)

          limpa()
          escreva("--- MODO DE EDIÇÃO SHIDO CODES ---\n")
          escreva("DICA: Comece com 'programa {' e termine com '}'.\n")
          escreva("-> Para SALVAR e SAIR, digite a palavra 'FIM' sozinha em uma linha.\n\n")
          
          codigo = ""
          linha = ""

          enquanto (linha != "FIM")
          {
            escreva(" > ")
            leia(linha)
            
            se (linha != "FIM")
            {
              codigo = codigo + linha + "\n"
            }
          }

          nomes_arquivos[total_arquivos] = nome_arquivo + ".por"
          conteudos_arquivos[total_arquivos] = codigo
          donos_arquivos[total_arquivos] = usuario_logado
          eh_zip[total_arquivos] = falso
          total_arquivos++

          escreva("\n[+] Código '", nome_arquivo, ".por' salvo no sistema!\n")
          u.aguarde(2000)
        }
        senao
        {
          escreva("\n[ERRO] O disco do sistema está cheio! Apague alguns arquivos.\n")
          u.aguarde(2000)
        }
      }
      senao se (op_ide == 2)
      {
        limpa()
        escreva("--- MEUS CÓDIGOS FONTE ---\n")
        inteiro encontrados = 0
        
        para (inteiro i = 0; i < total_arquivos; i++)
        {
          se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".por", nomes_arquivos[i], 0) != -1)
          {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            encontrados++
          }
        }

        se (encontrados == 0)
        {
          escreva("\nNenhum código fonte encontrado.\n")
          u.aguarde(2000)
        }
        senao
        {
          inteiro id_ler
          escreva("\nDigite o ID [ ] do código para ler (ou -1 para voltar): ")
          leia(id_ler)

          se (id_ler >= 0 e id_ler < total_arquivos e donos_arquivos[id_ler] == usuario_logado)
          {
            limpa()
            escreva("====================================\n")
            escreva(" CÓDIGO: ", nomes_arquivos[id_ler], "\n")
            escreva("====================================\n\n")
            escreva(conteudos_arquivos[id_ler])
            escreva("\n====================================\n")
            escreva("Pressione ENTER para voltar...")
            leia(pausa)
          }
          senao se (id_ler != -1)
          {
            escreva("\n[ERRO] ID Inválido!\n")
            u.aguarde(1500)
          }
        }
      }
      senao se (op_ide == 3)
      {
        limpa()
        escreva("--- SHIDO COMPILER ---\n")
        inteiro encontrados = 0
        
        para (inteiro i = 0; i < total_arquivos; i++)
        {
          se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".por", nomes_arquivos[i], 0) != -1)
          {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            encontrados++
          }
        }

        se (encontrados == 0)
        {
          escreva("\nNenhum código fonte para compilar.\n")
          u.aguarde(2000)
        }
        senao
        {
          inteiro id_exec
          escreva("\nDigite o ID [ ] do código para testar (ou -1 para voltar): ")
          leia(id_exec)

          se (id_exec >= 0 e id_exec < total_arquivos e donos_arquivos[id_exec] == usuario_logado)
          {
            limpa()
            escreva("Iniciando Análise Sintática em ", nomes_arquivos[id_exec], "...\n")
            u.aguarde(1500)
            
            cadeia cod = conteudos_arquivos[id_exec]
            
            logico tem_programa = (txt.posicao_texto("programa", cod, 0) != -1)
            logico tem_inicio = (txt.posicao_texto("inicio", cod, 0) != -1)
            logico tem_chaves = (txt.posicao_texto("{", cod, 0) != -1) e (txt.posicao_texto("}", cod, 0) != -1)

            se (tem_programa e tem_inicio e tem_chaves)
            {
              escreva("[ OK ] Estrutura base detectada.\n")
              u.aguarde(1000)
              
              escreva("\n================ TERMINAL VIRTUAL ================\n")
              
              // --- NOVA LÓGICA DE EXTRAÇÃO DO ESCREVA ---
              inteiro p_escreva = txt.posicao_texto("escreva", cod, 0)
              logico imprimiu_algo = falso

              enquanto (p_escreva != -1)
              {
                // Acha a primeira aspa depois da palavra escreva
                inteiro p_aspa1 = txt.posicao_texto("\"", cod, p_escreva)
                se (p_aspa1 != -1)
                {
                  // Acha a segunda aspa que fecha o texto
                  inteiro p_aspa2 = txt.posicao_texto("\"", cod, p_aspa1 + 1)
                  se (p_aspa2 != -1)
                  {
                    // Recorta o texto exato que está no meio das aspas
                    cadeia texto_dentro = txt.extrair_subtexto(cod, p_aspa1 + 1, p_aspa2)
                    escreva(texto_dentro, "\n")
                    imprimiu_algo = verdadeiro
                    
                    // Procura o próximo comando escreva a partir da aspa 2
                    p_escreva = txt.posicao_texto("escreva", cod, p_aspa2 + 1)
                  }
                  senao { p_escreva = -1 } // Sai se houver erro de aspas
                }
                senao { p_escreva = -1 }
              }

              se (imprimiu_algo == falso) 
              {
                escreva("> (Nenhuma saída de texto gerada pelo programa)\n")
              }
              
              se (txt.posicao_texto("leia", cod, 0) != -1)
              {
                escreva("\n> (Simulação) O programa executou captura de entrada de dados.\n")
              }
              
              escreva("==================================================\n")
            }
            senao
            {
              escreva("\n[ ERRO DE COMPILAÇÃO NO CÓDIGO ]\n")
              escreva("Faltam estruturas obrigatórias. Verifique se o seu código\n")
              escreva("possui 'programa {', 'funcao inicio()' e as chaves corretas.\n")
            }
            
            escreva("\nPressione ENTER para voltar ao menu...")
            leia(pausa)
          }
          senao se (id_exec != -1)
          {
            escreva("\n[ERRO] ID Inválido!\n")
            u.aguarde(1500)
          }
        }
      }
      senao se (op_ide != 4)
      {
        escreva("\nOpção Inválida!\n")
        u.aguarde(1500)
      }
    }
  }

  // === RESTO DOS APLICATIVOS (INTACTOS DO CÓDIGO ANTERIOR) ===

  funcao app_gerador_graficos()
  {
    inteiro op = 0
    cadeia pausa

    enquanto (op != 5) {
      limpa()
      escreva("--- CRIADOR DE GRÁFICOS ASCII V2.0 ---\n")
      escreva(" 1. Gráfico de Barras (Estatística)\n")
      escreva(" 2. Gráfico de Função Linear (y = ax + b)\n")
      escreva(" 3. Gráfico de Função Quadrática (y = ax² + bx + c)\n")
      escreva(" 4. Gráfico de Função Logarítmica (y = a * log_b(x))\n")
      escreva(" 5. Voltar\n")
      escreva("Escolha: ") leia(op)

      se (op == 1) {
        inteiro qtd
        escreva("\nQuantas barras deseja criar? (Máx 5): ") leia(qtd)
        se (qtd > 0 e qtd <= 5) {
          cadeia nomes[5]
          real valores[5], maior_valor = 0.0

          para(inteiro i=0; i<qtd; i++) {
            escreva("Nome da barra ", i+1, " (Curto): ") leia(nomes[i])
            escreva("Valor numérico da barra ", i+1, ": ") leia(valores[i])
            se (valores[i] > maior_valor) { maior_valor = valores[i] }
          }

          escreva("\n======================================================\n")
          escreva("                GRÁFICO DE BARRAS             \n")
          escreva("======================================================\n\n")
          
          escreva("             0         50%       100%\n")
          escreva("             |.........|.........|\n")

          para(inteiro i=0; i<qtd; i++) {
            inteiro tamanho_barra = 0
            se (maior_valor > 0) {
               tamanho_barra = mat.arredondar((valores[i] / maior_valor) * 20, 0)
            }
            
            cadeia rotulo = nomes[i]
            enquanto (txt.numero_caracteres(rotulo) < 12) {
               rotulo = " " + rotulo 
            }
            escreva(rotulo, " |")
            
            para(inteiro j=0; j<tamanho_barra; j++) { escreva("█") }
            escreva(" (", valores[i], ")\n")
          }
          escreva("\n======================================================\n")
        } senao {
          escreva("\nQuantidade inválida!\n")
        }
        escreva("Pressione ENTER para voltar...") leia(pausa)
      }
      senao se (op >= 2 e op <= 4) {
        real a = 0.0, b = 0.0, c = 0.0
        
        se (op == 2) {
           escreva("\nPlotador de Função Linear: y = ax + b\n")
           escreva("Digite o valor de a: ") leia(a)
           escreva("Digite o valor de b: ") leia(b)
        } senao se (op == 3) {
           escreva("\nPlotador de Função Quadrática: y = ax² + bx + c\n")
           escreva("Digite o valor de a: ") leia(a)
           escreva("Digite o valor de b: ") leia(b)
           escreva("Digite o valor de c: ") leia(c)
        } senao se (op == 4) {
           escreva("\nPlotador de Função Logarítmica: y = a * log(x) na base b\n")
           escreva("Digite o multiplicador 'a' (Ex: 1): ") leia(a)
           escreva("Digite a base do logaritmo 'b' (Ex: 10): ") leia(b)
           enquanto (b <= 0 ou b == 1) {
              escreva("[X] A base deve ser maior que 0 e diferente de 1. Digite novamente: ") leia(b)
           }
        }

        escreva("\n--- PLANO CARTESIANO (Visão Horizontal Melhorada) ---\n")
        escreva(" AVISO: O Eixo X desce na vertical e o Eixo Y vai para a direita.\n\n")
        
        escreva("              -20       -10        0       +10       +20\n")
        escreva("               |.........|.........|.........|.........|\n")

        para (inteiro x = -10; x <= 10; x++) {
           real y = 0.0
           logico valor_definido = verdadeiro

           se (op == 2) { 
              y = (a * x) + b 
           }
           senao se (op == 3) { 
              y = (a * (x * x)) + (b * x) + c 
           }
           senao se (op == 4) {
              se (x <= 0) {
                 valor_definido = falso 
              } senao {
                 y = a * mat.logaritmo(x * 1.0, b)
              }
           }

           cadeia rotulo_x = "X=" + x
           enquanto (txt.numero_caracteres(rotulo_x) < 5) {
              rotulo_x = " " + rotulo_x
           }

           se (nao valor_definido) {
              escreva(rotulo_x, "    |               |               |  (Indefinido)\n")
           } senao {
              inteiro pos_y = mat.arredondar(y, 0)
              escreva(rotulo_x, "    |")

              inteiro centro_y = 20 
              inteiro coluna_plot = centro_y + pos_y

              se (coluna_plot < 0) { coluna_plot = 0 }
              se (coluna_plot > 40) { coluna_plot = 40 } 

              para (inteiro espaco = 0; espaco <= 40; espaco++) {
                 se (espaco == coluna_plot) {
                    escreva("█") 
                 } senao se (espaco == centro_y) {
                    escreva("|") 
                 } senao se (espaco % 10 == 0) {
                    escreva(".") 
                 } senao {
                    escreva(" ")
                 }
              }
              escreva("  [Y = ", mat.arredondar(y, 2), "]\n")
           }
        }
        escreva("\nGráfico Concluído! Pressione ENTER para voltar...") leia(pausa)
      }
      senao se (op != 5) {
        escreva("\nOpção inválida!\n") u.aguarde(1000)
      }
    }
  }

  funcao app_calculadora()
  {
    inteiro op = 0
    real n1, n2, res
    cadeia pausa

    enquanto (op != 14) {
      limpa()
      escreva("--- CALCULADORA SUPER AVANÇADA ---\n")
      escreva(" 1. Somar            8. Maior Número\n")
      escreva(" 2. Subtrair         9. Menor Número\n")
      escreva(" 3. Multiplicar     10. Logaritmo\n")
      escreva(" 4. Dividir         11. Arredondar (Inteiro)\n")
      escreva(" 5. Potência        12. Valor Absoluto\n")
      escreva(" 6. Raiz Quadrada   13. Fatorial\n")
      escreva(" 7. Porcentagem     14. Sair\n")
      escreva("Escolha: ") leia(op)

      se (op >= 1 e op <= 13) {
        
        se (op == 6 ou op == 11 ou op == 12 ou op == 13) { 
          escreva("Digite o número: ") leia(n1)
          n2 = 0.0 
        } senao se (op == 7) {
          escreva("Digite a porcentagem (Ex: 20 para 20%): ") leia(n1)
          escreva("Digite o valor total: ") leia(n2)
        } senao se (op == 10) {
          escreva("Digite o número (Logaritmando): ") leia(n1)
          escreva("Digite a base do logaritmo: ") leia(n2)
        } senao {
          escreva("Digite o 1º número: ") leia(n1)
          escreva("Digite o 2º número: ") leia(n2)
        }

        escolha (op) {
          caso 1: 
            res = n1 + n2 
            escreva("\nResultado: ", n1, " + ", n2, " = ", res, "\n") 
          pare
          caso 2: 
            res = n1 - n2 
            escreva("\nResultado: ", n1, " - ", n2, " = ", res, "\n") 
          pare
          caso 3: 
            res = n1 * n2 
            escreva("\nResultado: ", n1, " * ", n2, " = ", res, "\n") 
          pare
          caso 4: 
            se (n2 == 0) { escreva("\n[ERRO] Impossível dividir por zero!\n") }
            senao { res = n1 / n2 escreva("\nResultado: ", n1, " / ", n2, " = ", res, "\n") }
          pare
          caso 5: 
            res = mat.potencia(n1, n2) 
            escreva("\nResultado: ", n1, " elevado a ", n2, " = ", res, "\n") 
          pare
          caso 6: 
            se (n1 < 0) { escreva("\n[ERRO] Raiz quadrada de número negativo não existe nos reais!\n") }
            senao { res = mat.raiz(n1, 2.0) escreva("\nResultado: Raiz de ", n1, " = ", res, "\n") }
          pare
          caso 7:
            res = (n1 * n2) / 100.0
            escreva("\nResultado: ", n1, "% de ", n2, " = ", res, "\n")
          pare
          caso 8:
            res = mat.maior_numero(n1, n2)
            escreva("\nResultado: O maior número entre ", n1, " e ", n2, " é ", res, "\n")
          pare
          caso 9:
            res = mat.menor_numero(n1, n2)
            escreva("\nResultado: O menor número entre ", n1, " e ", n2, " é ", res, "\n")
          pare
          caso 10:
            se (n1 <= 0 ou n2 <= 0 ou n2 == 1) {
              escreva("\n[ERRO] Valores inválidos para logaritmo!\n")
            } senao {
              res = mat.logaritmo(n1, n2)
              escreva("\nResultado: Logaritmo de ", n1, " na base ", n2, " = ", res, "\n")
            }
          pare
          caso 11:
            res = mat.arredondar(n1, 0)
            escreva("\nResultado: ", n1, " arredondado para o inteiro mais próximo é ", res, "\n")
          pare
          caso 12:
            res = mat.valor_absoluto(n1)
            escreva("\nResultado: O valor absoluto (módulo) de ", n1, " é ", res, "\n")
          pare
          caso 13:
            se (n1 < 0 ou n1 != mat.arredondar(n1, 0)) {
              escreva("\n[ERRO] O fatorial é calculado apenas para números inteiros positivos!\n")
            } senao {
              real fat = 1.0
              para (inteiro i = 1; i <= n1; i++) {
                fat = fat * i
              }
              escreva("\nResultado: O fatorial de ", n1, "! é ", fat, "\n")
            }
          pare
        }
        escreva("\nPressione ENTER para continuar...") leia(pausa)
      } senao se (op != 14) { escreva("\nOpção inválida!\n") u.aguarde(1000) }
    }
  }

  funcao app_agenda()
  {
    inteiro op = 0
    cadeia pausa
    enquanto (op != 5) {
      limpa()
      escreva("--- AGENDA DE CONTATOS ---\n")
      escreva("1. Adicionar Contato\n2. Listar Contatos\n3. Editar Contato\n4. Excluir Contato\n5. Sair\nEscolha: ") leia(op)

      se (op == 1) {
        se (total_contatos >= 20) { escreva("\n[X] Agenda lotada!\n") u.aguarde(1500) }
        senao {
          cadeia n, f
          escreva("\nNome: ") leia(n)
          escreva("Telefone: ") leia(f)
          agenda_nomes[total_contatos] = n
          agenda_fones[total_contatos] = f
          agenda_donos[total_contatos] = usuario_logado
          total_contatos++
          escreva("\n[!] Contato salvo!\n") u.aguarde(1500)
        }
      } senao se (op == 2) {
        escreva("\nMeus Contatos:\n")
        inteiro achados = 0
        para (inteiro i=0; i<total_contatos; i++) {
          se (agenda_donos[i] == usuario_logado) {
            escreva("-> ", agenda_nomes[i], " | Fone: ", agenda_fones[i], "\n")
            achados++
          }
        }
        se (achados == 0) { escreva("Nenhum contato salvo.\n") }
        escreva("\nPressione ENTER para voltar...") leia(pausa)
      } senao se (op == 3) {
        escreva("\n--- EDITAR CONTATO ---\n")
        se (total_contatos == 0) { escreva("Sua agenda está vazia.\n") u.aguarde(1500) }
        senao {
          cadeia busca 
          escreva("Digite o NOME exato do contato que deseja editar: ") leia(busca)
          logico achou = falso
          
          para (inteiro i = 0; i < total_contatos; i++) {
            se (agenda_donos[i] == usuario_logado e txt.caixa_alta(agenda_nomes[i]) == txt.caixa_alta(busca)) {
              escreva("\nContato encontrado: ", agenda_nomes[i], " - ", agenda_fones[i], "\n")
              escreva("Digite o NOVO Nome: ") leia(agenda_nomes[i])
              escreva("Digite o NOVO Telefone: ") leia(agenda_fones[i])
              escreva("\n[!] Contato atualizado com sucesso!\n")
              achou = verdadeiro pare
            }
          }
          se (nao achou) { escreva("\n[X] Contato '", busca, "' não encontrado.\n") }
          u.aguarde(2000)
        }
      } senao se (op == 4) {
        escreva("\n--- EXCLUIR CONTATO ---\n")
        se (total_contatos == 0) { escreva("Sua agenda está vazia.\n") u.aguarde(1500) }
        senao {
          cadeia busca 
          escreva("Digite o NOME exato do contato que deseja APAGAR: ") leia(busca)
          logico achou = falso
          
          para (inteiro i = 0; i < total_contatos; i++) {
            se (agenda_donos[i] == usuario_logado e txt.caixa_alta(agenda_nomes[i]) == txt.caixa_alta(busca)) {
              cadeia confirmacao 
              escreva("Tem certeza que deseja apagar o contato '", agenda_nomes[i], "'? (S/N): ") leia(confirmacao)
              
              se (txt.caixa_alta(confirmacao) == "S") {
                para (inteiro j = i; j < total_contatos - 1; j++) {
                  agenda_nomes[j] = agenda_nomes[j+1]
                  agenda_fones[j] = agenda_fones[j+1]
                  agenda_donos[j] = agenda_donos[j+1]
                }
                total_contatos--
                escreva("\n[!] Contato excluído com sucesso.\n")
              } senao {
                escreva("\n[!] Exclusão cancelada.\n")
              }
              achou = verdadeiro pare
            }
          }
          se (nao achou) { escreva("\n[X] Contato '", busca, "' não encontrado.\n") }
          u.aguarde(2000)
        }
      } senao se (op != 5) { escreva("\nOpção inválida!\n") u.aguarde(1000) }
    }
  }

  funcao app_cofre()
  {
    limpa()
    escreva("--- COFRE DE SENHAS ---\n")
    escreva("Área restrita. Digite sua senha de login do PortugOS para acessar: ")
    cadeia senha_dig
    leia(senha_dig)

    inteiro id_user = obter_indice_usuario(usuario_logado)
    se (senha_dig != banco_senhas[id_user]) {
      escreva("\n[X] Acesso Negado! Senha incorreta.\n") u.aguarde(2000) retorne
    }

    escreva("\n[!] Acesso Permitido. Entrando no Cofre...\n") u.aguarde(1500)

    inteiro op = 0 cadeia pausa
    enquanto (op != 5) {
      limpa()
      escreva("--- MEU COFRE SEGURO ---\n")
      escreva("1. Guardar Nova Senha\n2. Ver Minhas Senhas\n3. Editar Senha\n4. Excluir Senha\n5. Trancar Cofre e Sair\nEscolha: ") leia(op)

      se (op == 1) {
        se (total_cofre >= 20) { escreva("\n[X] Cofre lotado!\n") u.aguarde(1500) }
        senao {
          cadeia srv, sen
          escreva("\nNome do Site/Serviço (Ex: Instagram): ") leia(srv)
          escreva("Senha a ser guardada: ") leia(sen)
          cofre_servicos[total_cofre] = srv
          cofre_senhas_salvas[total_cofre] = sen
          cofre_donos[total_cofre] = usuario_logado
          total_cofre++
          escreva("\n[!] Senha trancada no cofre!\n") u.aguarde(1500)
        }
      } senao se (op == 2) {
        escreva("\nSenhas Guardadas:\n")
        inteiro achados = 0
        para (inteiro i=0; i<total_cofre; i++) {
          se (cofre_donos[i] == usuario_logado) {
            escreva("-> Serviço: ", cofre_servicos[i], " | Senha: ", cofre_senhas_salvas[i], "\n")
            achados++
          }
        }
        se (achados == 0) { escreva("Nenhuma senha no cofre.\n") }
        escreva("\nPressione ENTER para voltar...") leia(pausa)
      } senao se (op == 3) {
        escreva("\n--- EDITAR SENHA ---\n")
        se (total_cofre == 0) { escreva("Seu cofre está vazio.\n") u.aguarde(1500) }
        senao {
          cadeia busca 
          escreva("Digite o NOME do Serviço/Site que deseja editar: ") leia(busca)
          logico achou = falso
          
          para (inteiro i = 0; i < total_cofre; i++) {
            se (cofre_donos[i] == usuario_logado e txt.caixa_alta(cofre_servicos[i]) == txt.caixa_alta(busca)) {
              escreva("\nServiço encontrado: ", cofre_servicos[i], "\n")
              escreva("Digite a NOVA senha: ") leia(cofre_senhas_salvas[i])
              escreva("\n[!] Senha atualizada com sucesso!\n")
              achou = verdadeiro pare
            }
          }
          se (nao achou) { escreva("\n[X] Serviço '", busca, "' não encontrado no cofre.\n") }
          u.aguarde(2000)
        }
      } senao se (op == 4) {
        escreva("\n--- EXCLUIR SENHA ---\n")
        se (total_cofre == 0) { escreva("Seu cofre está vazio.\n") u.aguarde(1500) }
        senao {
          cadeia busca 
          escreva("Digite o NOME do Serviço/Site que deseja APAGAR: ") leia(busca)
          logico achou = falso
          
          para (inteiro i = 0; i < total_cofre; i++) {
            se (cofre_donos[i] == usuario_logado e txt.caixa_alta(cofre_servicos[i]) == txt.caixa_alta(busca)) {
              cadeia confirmacao 
              escreva("Tem certeza que deseja apagar a senha do serviço '", cofre_servicos[i], "'? (S/N): ") leia(confirmacao)
              
              se (txt.caixa_alta(confirmacao) == "S") {
                para (inteiro j = i; j < total_cofre - 1; j++) {
                  cofre_servicos[j] = cofre_servicos[j+1]
                  cofre_senhas_salvas[j] = cofre_senhas_salvas[j+1]
                  cofre_donos[j] = cofre_donos[j+1]
                }
                total_cofre--
                escreva("\n[!] Senha excluída com sucesso.\n")
              } senao {
                escreva("\n[!] Exclusão cancelada.\n")
              }
              achou = verdadeiro pare
            }
          }
          se (nao achou) { escreva("\n[X] Serviço '", busca, "' não encontrado no cofre.\n") }
          u.aguarde(2000)
        }
      } senao se (op == 5) { escreva("\nTrancando cofre...\n") u.aguarde(1000) }
      senao { escreva("\nOpção inválida!\n") u.aguarde(1000) }
    }
  }

  funcao app_cronometro()
  {
    cadeia iniciar, parar, pausa
    limpa()
    escreva("--- CRONÔMETRO ---\n")
    escreva("Digite qualquer coisa e aperte ENTER para INICIAR o cronômetro: ") leia(iniciar)
    
    inteiro tempo_inicio = u.tempo_decorrido()
    escreva("\n[!] Cronômetro rodando... Digite algo e aperte ENTER para PARAR: ") leia(parar)

    inteiro tempo_fim = u.tempo_decorrido()
    real total_segundos = (tempo_fim - tempo_inicio) / 1000.0

    escreva("\nTempo decorrido: ", total_segundos, " segundos.\n")
    escreva("\nPressione ENTER para sair...") leia(pausa)
  }

  funcao inteiro listar_arquivos_usuario(inteiro filtro)
  {
    inteiro contador = 0
    para (inteiro i = 0; i < total_arquivos; i++) {
      se (donos_arquivos[i] == usuario_logado) {
         se (filtro == 0 ou (filtro == 1 e eh_zip[i] == falso) ou (filtro == 2 e eh_zip[i] == verdadeiro)) {
           se (eh_zip[i]) {
             escreva(" -> ", nomes_arquivos[i], ".ZIP (Compactado)\n")
           } senao {
             escreva(" -> ", nomes_arquivos[i], ".TXT (", txt.numero_caracteres(conteudos_arquivos[i]), " bytes)\n")
           }
           contador++
         }
      }
    }
    retorne contador
  }

  funcao app_bloco_avancado()
  {
    inteiro op_bloco = 0
    cadeia pausa

    enquanto (op_bloco != 5)
    {
      limpa()
      escreva("====================================\n")
      escreva("     BLOCO DE NOTAS AVANÇADO        \n")
      escreva("====================================\n")
      escreva("  1. Novo Documento (.TXT)\n")
      escreva("  2. Ler Documento Existente\n")
      escreva("  3. Editar Documento (Adicionar)\n")
      escreva("  4. Excluir Documento\n")
      escreva("  5. Fechar Aplicativo\n")
      escreva("====================================\nEscolha: ")
      leia(op_bloco)

      se (op_bloco == 1)
      {
        se (total_arquivos < 20) {
          cadeia nome, txt_conteudo
          escreva("\nNome do arquivo (sem .txt): ")
          leia(nome)
          escreva("Digite o conteúdo do arquivo:\n> ")
          leia(txt_conteudo)

          nomes_arquivos[total_arquivos] = nome + ".txt"
          conteudos_arquivos[total_arquivos] = txt_conteudo
          donos_arquivos[total_arquivos] = usuario_logado
          eh_zip[total_arquivos] = falso
          total_arquivos++
          escreva("\n[+] Arquivo salvo com sucesso!\n")
          u.aguarde(1500)
        } senao {
          escreva("\n[ERRO] O disco do sistema está cheio!\n")
          u.aguarde(1500)
        }
      }
      senao se (op_bloco == 2)
      {
        limpa()
        escreva("--- MEUS DOCUMENTOS ---\n")
        inteiro achou = 0
        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e eh_zip[i] == falso e txt.posicao_texto(".txt", nomes_arquivos[i], 0) != -1) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou++
          }
        }
        se (achou == 0) {
          escreva("Nenhum arquivo TXT encontrado.\n")
          u.aguarde(1500)
        } senao {
          inteiro id_ler
          escreva("\nDigite o ID [ ] do arquivo para ler (ou -1 para cancelar): ")
          leia(id_ler)
          se (id_ler >= 0 e id_ler < total_arquivos e donos_arquivos[id_ler] == usuario_logado) {
            limpa()
            escreva("====================================\n")
            escreva(" LENDO: ", nomes_arquivos[id_ler], "\n")
            escreva("====================================\n\n")
            escreva(conteudos_arquivos[id_ler], "\n\n")
            escreva("====================================\n")
            escreva("Pressione ENTER para voltar...")
            leia(pausa)
          } senao se (id_ler != -1) {
            escreva("\n[ERRO] ID Inválido!\n")
            u.aguarde(1500)
          }
        }
      }
      senao se (op_bloco == 3)
      {
        limpa()
        escreva("--- EDITAR DOCUMENTO ---\n")
        inteiro achou_edit = 0
        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e eh_zip[i] == falso e txt.posicao_texto(".txt", nomes_arquivos[i], 0) != -1) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou_edit++
          }
        }
        se (achou_edit == 0) {
          escreva("Nenhum arquivo TXT encontrado para editar.\n")
          u.aguarde(1500)
        } senao {
          inteiro id_edit
          escreva("\nDigite o ID [ ] do arquivo para editar (ou -1 para cancelar): ")
          leia(id_edit)
          se (id_edit >= 0 e id_edit < total_arquivos e donos_arquivos[id_edit] == usuario_logado) {
            cadeia novo_txt
            escreva("\nConteúdo atual:\n", conteudos_arquivos[id_edit], "\n\n")
            escreva("Digite o texto para ADICIONAR ao final do arquivo:\n> ")
            leia(novo_txt)
            conteudos_arquivos[id_edit] = conteudos_arquivos[id_edit] + "\n" + novo_txt
            escreva("\n[+] Arquivo atualizado com sucesso!\n")
            u.aguarde(1500)
          } senao se (id_edit != -1) {
            escreva("\n[ERRO] ID Inválido!\n")
            u.aguarde(1500)
          }
        }
      }
      senao se (op_bloco == 4)
      {
        limpa()
        escreva("--- EXCLUIR DOCUMENTO ---\n")
        inteiro achou_del = 0
        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e eh_zip[i] == falso e txt.posicao_texto(".txt", nomes_arquivos[i], 0) != -1) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou_del++
          }
        }
        se (achou_del == 0) {
          escreva("Nenhum arquivo TXT encontrado para excluir.\n")
          u.aguarde(1500)
        } senao {
          inteiro id_del
          escreva("\nDigite o ID [ ] do arquivo para excluir (ou -1 para cancelar): ")
          leia(id_del)
          se (id_del >= 0 e id_del < total_arquivos e donos_arquivos[id_del] == usuario_logado) {
            // Lógica de excluir (arrastar vetor pra esquerda para fechar o "buraco")
            para (inteiro j = id_del; j < total_arquivos - 1; j++) {
              nomes_arquivos[j] = nomes_arquivos[j+1]
              conteudos_arquivos[j] = conteudos_arquivos[j+1]
              donos_arquivos[j] = donos_arquivos[j+1]
              eh_zip[j] = eh_zip[j+1]
              senhas_arquivos[j] = senhas_arquivos[j+1]
            }
            
            // Limpa o último slot duplicado na memória
            nomes_arquivos[total_arquivos - 1] = ""
            conteudos_arquivos[total_arquivos - 1] = ""
            donos_arquivos[total_arquivos - 1] = ""
            eh_zip[total_arquivos - 1] = falso
            senhas_arquivos[total_arquivos - 1] = ""
            
            total_arquivos--
            escreva("\n[+] Arquivo excluído permanentemente!\n")
            u.aguarde(1500)
          } senao se (id_del != -1) {
            escreva("\n[ERRO] ID Inválido!\n")
            u.aguarde(1500)
          }
        }
      }
      senao se (op_bloco != 5)
      {
        escreva("\nOpção Inválida!\n")
        u.aguarde(1500)
      }
    }
  }

  funcao app_meus_documentos()
  {
    limpa() escreva("--- LER ARQUIVO ---\n")
    se (listar_arquivos_usuario(0) == 0) { escreva("\nNenhum documento salvo.\n") u.aguarde(2000) retorne }

    cadeia busca, pausa
    escreva("\nDigite o nome do documento que deseja abrir: ") leia(busca)

    logico achou = falso
    para (inteiro i = 0; i < total_arquivos; i++) {
      se (donos_arquivos[i] == usuario_logado e nomes_arquivos[i] == busca) {
         achou = verdadeiro
         se (eh_zip[i]) {
            escreva("\n[X] Arquivo protegido no formato ZIP! Extraia-o usando o aplicativo PortuZIP primeiro.\n")
         } senao {
            limpa()
            escreva("====================================\n Lendo: ", nomes_arquivos[i], ".TXT\n====================================\n")
            escreva(conteudos_arquivos[i], "\n====================================\n")
         }
         pare
      }
    }
    se (achou == falso) { escreva("\n[X] Arquivo não encontrado.\n") }
    escreva("\nPressione ENTER para voltar...") leia(pausa)
  }

  funcao app_editar_arquivo()
  {
    limpa() escreva("--- EDITAR ARQUIVO ---\n")
    se (listar_arquivos_usuario(0) == 0) { escreva("\nNenhum documento salvo.\n") u.aguarde(2000) retorne }
    
    cadeia busca
    escreva("\nDigite o nome do arquivo que deseja editar: ") leia(busca)
    
    logico achou = falso
    para (inteiro i = 0; i < total_arquivos; i++) {
      se (donos_arquivos[i] == usuario_logado e nomes_arquivos[i] == busca) {
         achou = verdadeiro
         se (eh_zip[i]) {
            escreva("\n[X] Impossível editar arquivos .ZIP! Extraia-o usando o aplicativo PortuZIP primeiro.\n")
         } senao {
            escreva("\n[CONTEÚDO ATUAL]\n", conteudos_arquivos[i], "\n")
            escreva("\nO que deseja fazer?\n [1] Sobrescrever tudo (Apagar o antigo e colocar novo)\n [2] Adicionar ao final (Continuar escrevendo)\nEscolha: ")
            
            inteiro op leia(op)
            cadeia novo_texto escreva("\nDigite o novo texto:\n> ") leia(novo_texto)
            
            se (op == 1) { 
              conteudos_arquivos[i] = novo_texto 
            } senao { 
              conteudos_arquivos[i] = conteudos_arquivos[i] + " " + novo_texto 
            }
            escreva("\n[!] Arquivo atualizado com sucesso!\n")
         }
         pare
      }
    }
    se (achou == falso) { escreva("\n[X] Arquivo não encontrado.\n") }
    u.aguarde(2500)
  }

  funcao app_excluir_arquivo()
  {
    limpa() escreva("--- EXCLUIR ARQUIVO ---\n")
    se (listar_arquivos_usuario(0) == 0) { escreva("\nNenhum documento salvo.\n") u.aguarde(2000) retorne }
    
    cadeia busca, confirmacao
    escreva("\nDigite o nome do arquivo que deseja APAGAR: ") leia(busca)
    
    logico achou = falso
    para (inteiro i = 0; i < total_arquivos; i++) {
      se (donos_arquivos[i] == usuario_logado e nomes_arquivos[i] == busca) {
         achou = verdadeiro
         
         se (eh_zip[i]) {
            escreva("Tem certeza que deseja apagar o compactado '", nomes_arquivos[i], ".ZIP'? (S/N): ")
         } senao {
            escreva("Tem certeza que deseja apagar '", nomes_arquivos[i], ".TXT'? (S/N): ")
         }
         
         leia(confirmacao)
         
         se (txt.caixa_alta(confirmacao) == "S") {
           para (inteiro j = i; j < total_arquivos - 1; j++) {
              nomes_arquivos[j] = nomes_arquivos[j+1]
              conteudos_arquivos[j] = conteudos_arquivos[j+1]
              donos_arquivos[j] = donos_arquivos[j+1]
              eh_zip[j] = eh_zip[j+1]
              senhas_arquivos[j] = senhas_arquivos[j+1]
           }
           total_arquivos-- 
           escreva("\n[!] Arquivo excluído com sucesso. Espaço liberado!\n")
         } senao {
           escreva("\n[!] Exclusão cancelada.\n")
         }
         pare
      }
    }
    se (achou == falso) { escreva("\n[X] Arquivo não encontrado.\n") }
    u.aguarde(2500)
  }

funcao app_portuzip()
  {
    inteiro op_zip = 0
    cadeia pausa

    enquanto (op_zip != 6)
    {
      limpa()
      escreva("====================================\n")
      escreva("          PORTUZIP V4.0             \n")
      escreva("====================================\n")
      escreva("  1. Compactar Códigos (.por)\n")
      escreva("  2. Compactar Bloco de Notas (.txt)\n")
      escreva("  3. Compactar Agenda de Contatos\n")
      escreva("  4. Extrair/Ver Arquivos Compactados\n")
      escreva("  5. Excluir Arquivo .ZIP\n")
      escreva("  6. Voltar ao Menu\n")
      escreva("====================================\nEscolha: ")
      leia(op_zip)

      // --- OPÇÃO 1: COMPACTAR CÓDIGOS ---
      se (op_zip == 1)
      {
        limpa()
        escreva("--- SELECIONAR CÓDIGOS PARA ZIP ---\n")
        inteiro selecionados[20], qtd_sel = 0, id_sel = 0, achou_por = 0

        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".por", nomes_arquivos[i], 0) != -1 e eh_zip[i] == falso) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou_por++
          }
        }

        se (achou_por == 0) {
          escreva("\nNenhum código .por encontrado para compactar.\n")
          u.aguarde(2000)
        } senao {
          escreva("\n")
          enquanto (id_sel != -1 e qtd_sel < 20) {
            escreva("Digite o ID para adicionar (ou -1 para finalizar): ")
            leia(id_sel)
            se (id_sel != -1) {
              se (id_sel >= 0 e id_sel < total_arquivos e donos_arquivos[id_sel] == usuario_logado e txt.posicao_texto(".por", nomes_arquivos[id_sel], 0) != -1 e eh_zip[id_sel] == falso) {
                selecionados[qtd_sel] = id_sel
                qtd_sel++
                escreva(" -> Arquivo adicionado ao pacote!\n")
              } senao {
                escreva(" -> [ERRO] ID inválido, não existe ou não é um código!\n")
              }
            }
          }

          se (qtd_sel > 0) {
            cadeia nome_zip, conteudo_final = "", quer_senha, senha_zip = ""
            escreva("\nNome do arquivo final (sem .zip): ")
            leia(nome_zip)
            
            escreva("Deseja proteger este ZIP com senha? (S/N): ")
            leia(quer_senha)
            se (quer_senha == "S" ou quer_senha == "s") {
              escreva("Digite a senha do pacote: ")
              leia(senha_zip)
            }

            para (inteiro j = 0; j < qtd_sel; j++) {
              inteiro idx = selecionados[j]
              conteudo_final = conteudo_final + "FILE:" + nomes_arquivos[idx] + "\n" + conteudos_arquivos[idx] + "\n---\n"
            }

            nomes_arquivos[total_arquivos] = nome_zip + ".zip"
            conteudos_arquivos[total_arquivos] = conteudo_final
            donos_arquivos[total_arquivos] = usuario_logado
            eh_zip[total_arquivos] = verdadeiro
            senhas_arquivos[total_arquivos] = senha_zip
            total_arquivos++

            escreva("\n[OK] ", qtd_sel, " códigos compactados em '", nome_zip, ".zip'!\n")
            u.aguarde(2000)
          }
        }
      }
      // --- OPÇÃO 2: COMPACTAR BLOCO DE NOTAS ---
      senao se (op_zip == 2) 
      {
        limpa()
        escreva("--- SELECIONAR NOTAS PARA ZIP ---\n")
        inteiro selecionados_txt[20], qtd_sel_txt = 0, id_sel_txt = 0, achou_txt = 0

        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e txt.posicao_texto(".txt", nomes_arquivos[i], 0) != -1 e eh_zip[i] == falso) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou_txt++
          }
        }

        se (achou_txt == 0) {
          escreva("\nNenhum arquivo de texto encontrado.\n")
          u.aguarde(2000)
        } senao {
          escreva("\n")
          enquanto (id_sel_txt != -1 e qtd_sel_txt < 20) {
            escreva("Digite o ID para adicionar (ou -1 para finalizar): ")
            leia(id_sel_txt)
            se (id_sel_txt != -1) {
              se (id_sel_txt >= 0 e id_sel_txt < total_arquivos e donos_arquivos[id_sel_txt] == usuario_logado e txt.posicao_texto(".txt", nomes_arquivos[id_sel_txt], 0) != -1 e eh_zip[id_sel_txt] == falso) {
                selecionados_txt[qtd_sel_txt] = id_sel_txt
                qtd_sel_txt++
                escreva(" -> Arquivo de texto adicionado ao pacote!\n")
              } senao {
                escreva(" -> [ERRO] ID inválido!\n")
              }
            }
          }

          se (qtd_sel_txt > 0) {
            cadeia nome_zip, conteudo_final = "", quer_senha, senha_zip = ""
            escreva("\nNome do arquivo final (sem .zip): ")
            leia(nome_zip)
            
            escreva("Deseja proteger este ZIP com senha? (S/N): ")
            leia(quer_senha)
            se (quer_senha == "S" ou quer_senha == "s") {
              escreva("Digite a senha do pacote: ")
              leia(senha_zip)
            }

            para (inteiro j = 0; j < qtd_sel_txt; j++) {
              inteiro idx = selecionados_txt[j]
              conteudo_final = conteudo_final + "FILE:" + nomes_arquivos[idx] + "\n" + conteudos_arquivos[idx] + "\n---\n"
            }

            nomes_arquivos[total_arquivos] = nome_zip + ".zip"
            conteudos_arquivos[total_arquivos] = conteudo_final
            donos_arquivos[total_arquivos] = usuario_logado
            eh_zip[total_arquivos] = verdadeiro
            senhas_arquivos[total_arquivos] = senha_zip
            total_arquivos++

            escreva("\n[OK] ", qtd_sel_txt, " notas compactadas em '", nome_zip, ".zip'!\n")
            u.aguarde(2000)
          }
        }
      }
      // --- OPÇÃO 3: COMPACTAR AGENDA ---
      senao se (op_zip == 3)
      {
        limpa()
        escreva("--- COMPACTAR AGENDA DE CONTATOS ---\n")
        
        cadeia nome_backup, backup_texto = "--- BACKUP DE CONTATOS PORTUGOS ---\n", quer_senha, senha_zip = ""
        escreva("Nome do arquivo de backup (sem .zip): ")
        leia(nome_backup)

        escreva("Deseja proteger este backup com senha? (S/N): ")
        leia(quer_senha)
        se (quer_senha == "S" ou quer_senha == "s") {
          escreva("Digite a senha do pacote: ")
          leia(senha_zip)
        }

        inteiro contatos_salvos = 0
        para (inteiro c = 0; c < 20; c++) { 
          se (agenda_nomes[c] != "" e agenda_donos[c] == usuario_logado) {
            backup_texto = backup_texto + "NOME: " + agenda_nomes[c] + " | TEL: " + agenda_fones[c] + "\n"
            contatos_salvos++
          }
        }

        se (contatos_salvos > 0) {
          nomes_arquivos[total_arquivos] = nome_backup + ".zip"
          conteudos_arquivos[total_arquivos] = backup_texto
          donos_arquivos[total_arquivos] = usuario_logado
          eh_zip[total_arquivos] = verdadeiro
          senhas_arquivos[total_arquivos] = senha_zip
          total_arquivos++

          escreva("\n[OK] Backup de ", contatos_salvos, " contatos salvo!\n")
        } senao {
          escreva("\n[ERRO] Sua agenda está vazia! Nada foi salvo.\n")
        }
        u.aguarde(2000)
      }
      // --- OPÇÃO 4: LER ARQUIVOS ZIPADOS ---
      senao se (op_zip == 4)
      {
        limpa()
        escreva("--- EXTRAIR / VISUALIZAR ARQUIVOS .ZIP ---\n")
        inteiro achou_zip = 0
        
        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e eh_zip[i] == verdadeiro) {
            escreva(" [", i, "] - ", nomes_arquivos[i])
            se (senhas_arquivos[i] != "") { escreva(" [PROTEGIDO]") }
            escreva("\n")
            achou_zip++
          }
        }

        se (achou_zip == 0) {
          escreva("\nNenhum pacote .zip encontrado.\n")
          u.aguarde(2000)
        } senao {
          inteiro id_zip
          escreva("\nDigite o ID do pacote ZIP para ler (ou -1 para cancelar): ")
          leia(id_zip)

          se (id_zip != -1) {
            se (id_zip >= 0 e id_zip < total_arquivos e donos_arquivos[id_zip] == usuario_logado e eh_zip[id_zip] == verdadeiro) {
              
              logico acesso_liberado = verdadeiro
              se (senhas_arquivos[id_zip] != "") {
                cadeia tentativa_senha
                escreva("\n[!] ARQUIVO PROTEGIDO. Digite a senha: ")
                leia(tentativa_senha)
                se (tentativa_senha != senhas_arquivos[id_zip]) {
                  escreva("\n[ERRO] Senha Incorreta. Acesso Negado!\n")
                  acesso_liberado = falso
                  u.aguarde(2000)
                }
              }

              se (acesso_liberado) {
                limpa()
                escreva("=== CONTEÚDO DO PACOTE: ", nomes_arquivos[id_zip], " ===\n\n")
                escreva(conteudos_arquivos[id_zip])
                escreva("\n==========================================\n")
                escreva("Pressione ENTER para fechar o pacote...")
                leia(pausa)
              }
            } senao {
              escreva("\n[ERRO] ID Inválido!\n")
              u.aguarde(2000)
            }
          }
        }
      }
      // --- OPÇÃO 5: EXCLUIR ZIP ---
      senao se (op_zip == 5)
      {
        limpa()
        escreva("--- EXCLUIR ARQUIVO .ZIP ---\n")
        inteiro achou_del = 0
        
        para (inteiro i = 0; i < total_arquivos; i++) {
          se (donos_arquivos[i] == usuario_logado e eh_zip[i] == verdadeiro) {
            escreva(" [", i, "] - ", nomes_arquivos[i], "\n")
            achou_del++
          }
        }

        se (achou_del == 0) {
          escreva("\nNenhum pacote .zip encontrado para exclusão.\n")
          u.aguarde(2000)
        } senao {
          inteiro id_del
          escreva("\nDigite o ID do ZIP para excluir (ou -1 para cancelar): ")
          leia(id_del)

          se (id_del != -1) {
            se (id_del >= 0 e id_del < total_arquivos e donos_arquivos[id_del] == usuario_logado e eh_zip[id_del] == verdadeiro) {
              
              logico pode_excluir = verdadeiro
              se (senhas_arquivos[id_del] != "") {
                cadeia senha_del
                escreva("\n[!] ARQUIVO PROTEGIDO. Digite a senha para excluir: ")
                leia(senha_del)
                se (senha_del != senhas_arquivos[id_del]) {
                  escreva("\n[ERRO] Senha Incorreta. Exclusão Cancelada!\n")
                  pode_excluir = falso
                  u.aguarde(2000)
                }
              }

              se (pode_excluir) {
                // Arrasta os arquivos pra esquerda pra fechar o buraco
                para (inteiro j = id_del; j < total_arquivos - 1; j++) {
                  nomes_arquivos[j] = nomes_arquivos[j+1]
                  conteudos_arquivos[j] = conteudos_arquivos[j+1]
                  donos_arquivos[j] = donos_arquivos[j+1]
                  eh_zip[j] = eh_zip[j+1]
                  senhas_arquivos[j] = senhas_arquivos[j+1]
                }
                
                // Limpa o ultimo registro duplicado
                total_arquivos--
                nomes_arquivos[total_arquivos] = ""
                conteudos_arquivos[total_arquivos] = ""
                donos_arquivos[total_arquivos] = ""
                eh_zip[total_arquivos] = falso
                senhas_arquivos[total_arquivos] = ""
                
                escreva("\n[+] Pacote excluído permanentemente do disco!\n")
                u.aguarde(2000)
              }
            } senao {
              escreva("\n[ERRO] ID Inválido!\n")
              u.aguarde(2000)
            }
          }
        }
      }
      senao se (op_zip != 6)
      {
        escreva("\nOpção Inválida!\n")
        u.aguarde(1500)
      }
    }
  }

  // --- MÓDULO DE CONFIGURAÇÕES E SISTEMA ---

  funcao inteiro abrir_configuracoes()
  {
    inteiro opcao_config = 0
    cadeia senha_atual, nova_senha, confirmacao_senha, novo_usuario, senha_digitada, pausa 
    inteiro meu_indice = obter_indice_usuario(usuario_logado)

    enquanto (opcao_config != 8) 
    {
      limpa()
      escreva("====================================\n    CONFIGURAÇÕES DO SISTEMA        \n====================================\n")
      escreva(" Usuário logado: ", usuario_logado)
      se (eh_admin[meu_indice]) { escreva(" [ADMINISTRADOR]\n") } senao { escreva("\n") }
      escreva("------------------------------------\n 1. Alterar Minha Senha\n 2. Alterar Meu Nome de Usuário\n 3. Criar Novo Usuário (Apenas Admin)\n 4. Informações de Hardware\n 5. Configurações de Wi-Fi\n 6. Fazer Logout\n 7. Reiniciar Sistema\n 8. Voltar ao Terminal\n====================================\nEscolha uma opção: ")
      leia(opcao_config)

      escolha (opcao_config) {
        caso 1:
          escreva("\n--- ALTERAÇÃO DE SENHA ---\nDigite sua senha atual: ") leia(senha_atual)
          se (senha_atual == banco_senhas[meu_indice]) {
            escreva("Digite a NOVA senha: ") leia(nova_senha)
            escreva("Confirme a NOVA senha: ") leia(confirmacao_senha)
            se (nova_senha == confirmacao_senha) { banco_senhas[meu_indice] = nova_senha escreva("\n[!] Senha alterada com sucesso!\n") } 
            senao { escreva("\n[X] Erro: As senhas não coincidem.\n") }
          } senao { escreva("\n[X] Erro: Senha incorreta.\n") }
          u.aguarde(2500) pare

        caso 2:
          escreva("\n--- ALTERAÇÃO DE USUÁRIO ---\nDigite sua senha atual: ") leia(senha_digitada)
          se (senha_digitada == banco_senhas[meu_indice]) {
            escreva("Digite o NOVO nome de usuário: ") leia(novo_usuario)
            se (obter_indice_usuario(novo_usuario) != -1 e novo_usuario != usuario_logado) { escreva("\n[X] Erro: O usuário já existe.\n") } 
            senao {
              para (inteiro i = 0; i < total_arquivos; i++) {
                se (donos_arquivos[i] == usuario_logado) { donos_arquivos[i] = novo_usuario }
              }
              para (inteiro i = 0; i < total_contatos; i++) {
                se (agenda_donos[i] == usuario_logado) { agenda_donos[i] = novo_usuario }
              }
              para (inteiro i = 0; i < total_cofre; i++) {
                se (cofre_donos[i] == usuario_logado) { cofre_donos[i] = novo_usuario }
              }
              banco_usuarios[meu_indice] = novo_usuario usuario_logado = novo_usuario
              escreva("\n[!] Nome alterado com sucesso!\n")
            }
          } senao { escreva("\n[X] Erro: Senha incorreta.\n") }
          u.aguarde(2500) pare
        
        caso 3:
          escreva("\n--- CRIAR NOVO USUÁRIO ---\n")
          se (eh_admin[meu_indice] == falso) { escreva("[X] Acesso Negado! Apenas Admin.\n") }
          senao se (total_usuarios >= 10) { escreva("[X] Banco cheio!\n") }
          senao {
            cadeia nome_novo, senha_nova
            escreva("Nome do novo usuário: ") leia(nome_novo)
            se (obter_indice_usuario(nome_novo) != -1) { escreva("\n[X] Usuário já existe!\n") }
            senao {
              escreva("Senha para '", nome_novo, "': ") leia(senha_nova)
              banco_usuarios[total_usuarios] = nome_novo
              banco_senhas[total_usuarios] = senha_nova
              eh_admin[total_usuarios] = falso 
              total_usuarios++ 
              escreva("\n[!] Usuário registrado!\n")
            }
          }
          u.aguarde(2500) pare

        caso 4:
          escreva("\n--- INFORMAÇÕES ---\nMemória RAM: 1024 KB\nProcessador: CPU PortuCPU V1\nBanco de Usuários: ", total_usuarios, "/10\nArquivos Salvos: ", total_arquivos, "/20\nPerguntas no Quiz: ", total_bd_quiz, "/200\nWi-Fi: ") se (wifi_conectado) { escreva("Conectado (", rede_atual, ")\n") } senao { escreva("Desconectado\n") }
          escreva("-------------------\nPressione ENTER para continuar...") leia(pausa) pare
          
        caso 5: menu_wifi() pare
        caso 6: escreva("\nSaindo da conta...\n") u.aguarde(1000) limpa() retorne 1 
        caso 7: escreva("\nIniciando processo de reinicialização...\n") u.aguarde(1000) limpa() retorne 2
        caso 8: escreva("\nVoltando...\n") u.aguarde(800) limpa() retorne 0 
        caso contrario: escreva("\nOpção inválida!\n") u.aguarde(1500)
      }
    }
    retorne 0
  }

  funcao menu_wifi()
  {
    inteiro opcao_wifi = 0
    cadeia pausa

    enquanto (opcao_wifi != 5) {
      limpa()
      escreva("====================================\n         GERENCIADOR WI-FI          \n====================================\n Status: ")
      se (wifi_conectado) { escreva("Conectado à rede '", rede_atual, "'\n") } senao { escreva("Desconectado\n") }
      escreva("------------------------------------\n 1. Listar Redes Disponíveis\n 2. Conectar a uma Rede\n 3. Verificar Internet (Diagnóstico)\n 4. Desconectar\n 5. Voltar às Configurações\n====================================\nEscolha uma opção: ")
      leia(opcao_wifi)

      escolha (opcao_wifi) {
        caso 1:
          escreva("\n--- REDES DISPONÍVEIS ---\n")
          para(inteiro i = 0; i < 4; i++) {
            escreva(" [", i + 1, "] ", redes_disponiveis[i])
            se (senhas_wifi[i] == "") { escreva(" (Aberta)\n") } senao { escreva(" (Protegida)\n") }
          }
          escreva("\nPressione ENTER para voltar...") leia(pausa) pare

        caso 2:
          escreva("\n--- CONECTAR ---\nDigite o nome exato da rede: ") cadeia nome_rede leia(nome_rede)
          logico rede_encontrada = falso inteiro indice_rede = -1

          para(inteiro i = 0; i < 4; i++) {
            se (txt.caixa_alta(nome_rede) == txt.caixa_alta(redes_disponiveis[i])) { rede_encontrada = verdadeiro nome_rede = redes_disponiveis[i] indice_rede = i pare }
          }

          se (rede_encontrada) {
            logico senha_correta = falso cadeia senha_digitada = ""

            se (senhas_wifi[indice_rede] == "") {
               escreva("\nRede aberta detectada! Conectando sem senha...\n") senha_correta = verdadeiro
            } senao {
               escreva("Digite a senha para '", nome_rede, "': ") leia(senha_digitada)
               se (senha_digitada == senhas_wifi[indice_rede]) { senha_correta = verdadeiro } senao { escreva("\n[X] Falha: Senha incorreta!\n") }
            }

            se (senha_correta) {
              escreva("\nAutenticando...\n") u.aguarde(1500)
              escreva("Obtendo endereço IP...\n") u.aguarde(1500)
              wifi_conectado = verdadeiro rede_atual = nome_rede
              escreva("\n[!] Conectado com sucesso à rede ", rede_atual, "!\n")
            }
          } senao { escreva("\n[X] Rede '", nome_rede, "' não encontrada!\n") }
          u.aguarde(2500) pare

        caso 3:
          escreva("\n--- DIAGNÓSTICO DE REDE ---\n")
          se (wifi_conectado) {
            escreva("Disparando contra 8.8.8.8 com 32 bytes de dados:\n\n") u.aguarde(1000)
            escreva("Resposta de 8.8.8.8: bytes=32 tempo=", u.sorteia(10, 45), "ms\n") u.aguarde(800)
            escreva("Resposta de 8.8.8.8: bytes=32 tempo=", u.sorteia(10, 45), "ms\n") u.aguarde(800)
            escreva("Resposta de 8.8.8.8: bytes=32 tempo=", u.sorteia(10, 45), "ms\n\n[!] Conexão com a Internet operando perfeitamente.\n")
          } senao { escreva("[X] Erro: Desconectado.\n") }
          escreva("\nPressione ENTER para voltar...") leia(pausa) pare

        caso 4:
          se (wifi_conectado) {
            escreva("\nDesconectando...\n") u.aguarde(1000) wifi_conectado = falso rede_atual = "" escreva("[!] Desconectado.\n")
          } senao { escreva("\n[!] Você já está desconectado.\n") }
          u.aguarde(2000) pare

        caso 5: escreva("\nVoltando...\n") u.aguarde(500) pare
        caso contrario: escreva("\nOpção inválida!\n") u.aguarde(1500)
      }
    }
  }

  // --- MÓDULO DE JOGOS COMPLETO ---

  funcao abrir_jogos()
  {
    inteiro opcao_jogo = 0

    enquanto (opcao_jogo != 7) 
    {
      limpa()
      escreva("====================================\n       FLIPERAMA PORTUGOS           \n====================================\n")
      escreva(" 1. Jogo da Adivinhação\n 2. Par ou Ímpar vs Computador\n 3. Jogo da Velha (2 Jogadores)\n 4. Jogo da Forca\n 5. Jokenpô (Pedra, Papel, Tesoura)\n 6. Quiz de Informática (Avançado)\n 7. Sair dos Jogos\n====================================\nEscolha uma opção: ")
      leia(opcao_jogo)

      escolha (opcao_jogo) {
        caso 1: jogo_adivinhacao() pare
        caso 2: jogo_par_impar() pare
        caso 3: jogo_da_velha() pare
        caso 4: jogo_da_forca() pare 
        caso 5: jogo_jokenpo() pare
        caso 6: jogo_quiz_avancado() pare
        caso 7: escreva("\nFechando...\n") u.aguarde(800) limpa() pare
        caso contrario: escreva("\nOpção inválida!\n") u.aguarde(1500)
      }
    }
  }

  funcao jogo_adivinhacao()
  {
    inteiro num_secreto = u.sorteia(1, 100), palpite = 0, tentativas = 0
    cadeia pausa
    limpa() escreva("--- ADIVINHAÇÃO ---\nO computador pensou num número de 1 a 100.\n\n")
    enquanto (palpite != num_secreto) {
      escreva("Palpite: ") leia(palpite) tentativas++
      se (palpite < num_secreto) { escreva("-> Maior!\n\n") }
      senao se (palpite > num_secreto) { escreva("-> Menor!\n\n") }
      senao { escreva("\n[!] PARABÉNS! Você acertou em ", tentativas, " tentativas!\n") }
    }
    escreva("\nPressione ENTER para voltar...") leia(pausa)
  }

  funcao jogo_par_impar()
  {
    cadeia escolha_jogador, pausa inteiro num_jogador, num_pc, soma
    limpa() escreva("--- PAR OU ÍMPAR ---\nVocê quer Par (P) ou Ímpar (I)? ") leia(escolha_jogador)
    escolha_jogador = txt.caixa_alta(escolha_jogador)
    se (escolha_jogador == "P" ou escolha_jogador == "I") {
      escreva("Digite de 0 a 10: ") leia(num_jogador)
      num_pc = u.sorteia(0, 10) soma = num_jogador + num_pc
      escreva("\nPC: ", num_pc, " | Total: ", soma, "\n")
      se (soma % 2 == 0) {
        escreva("Resultado: PAR!\n")
        se (escolha_jogador == "P") { escreva(">> Você VENCEU! <<\n") } senao { escreva(">> PC VENCEU! <<\n") }
      } senao {
        escreva("Resultado: ÍMPAR!\n")
        se (escolha_jogador == "I") { escreva(">> Você VENCEU! <<\n") } senao { escreva(">> PC VENCEU! <<\n") }
      }
    } senao { escreva("\n[!] Inválido.\n") }
    escreva("\nPressione ENTER para voltar...") leia(pausa)
  }

  funcao jogo_da_velha()
  {
    cadeia tab[3][3] = { {"1","2","3"}, {"4","5","6"}, {"7","8","9"} }
    inteiro jogadas = 0, linha = 0, coluna = 0, posicao
    cadeia jogador_atual = "X", vencedor = "", pausa
    logico jogada_valida

    enquanto (vencedor == "" e jogadas < 9) {
      limpa()
      escreva("--- JOGO DA VELHA ---\n\n  ", tab[0][0], " | ", tab[0][1], " | ", tab[0][2], " \n ---|---|---\n  ", tab[1][0], " | ", tab[1][1], " | ", tab[1][2], " \n ---|---|---\n  ", tab[2][0], " | ", tab[2][1], " | ", tab[2][2], " \n\n")
      escreva("Vez do jogador [ ", jogador_atual, " ]\nEscolha uma posição (1-9): ") leia(posicao)

      jogada_valida = falso

      se (posicao >= 1 e posicao <= 9) {
        escolha (posicao) {
          caso 1: linha = 0 coluna = 0 pare
          caso 2: linha = 0 coluna = 1 pare
          caso 3: linha = 0 coluna = 2 pare
          caso 4: linha = 1 coluna = 0 pare
          caso 5: linha = 1 coluna = 1 pare
          caso 6: linha = 1 coluna = 2 pare
          caso 7: linha = 2 coluna = 0 pare
          caso 8: linha = 2 coluna = 1 pare
          caso 9: linha = 2 coluna = 2 pare
        }
        se (tab[linha][coluna] != "X" e tab[linha][coluna] != "O") { tab[linha][coluna] = jogador_atual jogada_valida = verdadeiro jogadas++ }
      }

      se (jogada_valida == falso) { escreva("\n[!] Jogada inválida. Tente novamente.\n") u.aguarde(1500) }
      senao {
        para (inteiro i = 0; i < 3; i++) { se (tab[i][0] == tab[i][1] e tab[i][1] == tab[i][2]) { vencedor = tab[i][0] } }
        para (inteiro i = 0; i < 3; i++) { se (tab[0][i] == tab[1][i] e tab[1][i] == tab[2][i]) { vencedor = tab[0][i] } }
        se (tab[0][0] == tab[1][1] e tab[1][1] == tab[2][2]) { vencedor = tab[0][0] }
        se (tab[0][2] == tab[1][1] e tab[1][1] == tab[2][0]) { vencedor = tab[0][2] }

        se (jogador_atual == "X") { jogador_atual = "O" } senao { jogador_atual = "X" }
      }
    } 

    limpa()
    escreva("--- RESULTADO DO JOGO DA VELHA ---\n\n  ", tab[0][0], " | ", tab[0][1], " | ", tab[0][2], " \n ---|---|---\n  ", tab[1][0], " | ", tab[1][1], " | ", tab[1][2], " \n ---|---|---\n  ", tab[2][0], " | ", tab[2][1], " | ", tab[2][2], " \n\n")
    se (vencedor != "") { escreva(">>> Parabéns! O jogador [ ", vencedor, " ] venceu! <<<\n") } senao { escreva(">>> Deu VELHA! O jogo empatou. <<<\n") }
    escreva("\nPressione ENTER para voltar ao menu de jogos...") leia(pausa)
  }

  funcao jogo_da_forca()
  {
    inteiro indice = u.sorteia(0, 19) 
    cadeia palavra_secreta = forca_palavras[indice]
    inteiro tamanho = txt.numero_caracteres(palavra_secreta)
    
    cadeia revelado[20]
    inteiro acertos = 0, erros = 0
    cadeia letra, pausa

    para (inteiro i = 0; i < tamanho; i++) { revelado[i] = "_" }

    enquanto (erros < 6 e acertos < tamanho)
    {
      limpa()
      escreva("--- JOGO DA FORCA ---\n")
      
      se (cheat_forca) {
        escreva("\n[HACKER DETECTADO] Dica do terminal: A palavra é ", palavra_secreta, "\n\n")
      } senao {
        escreva("\n")
      }

      escreva(" +---+\n |   |\n")
      se (erros >= 1) { escreva(" |   O\n") } senao { escreva(" |\n") }
      se (erros == 2) { escreva(" |   |\n") } senao se (erros == 3) { escreva(" |  /|\n") } senao se (erros >= 4) { escreva(" |  /|\\\n") } senao { escreva(" |\n") }
      se (erros == 5) { escreva(" |  /\n") } senao se (erros >= 6) { escreva(" |  / \\\n") } senao { escreva(" |\n") }
      escreva(" |\n=========\n\nPalavra: ")

      para (inteiro i = 0; i < tamanho; i++) { escreva(revelado[i], " ") }
      escreva("\n\nErros: ", erros, " de 6\nDigite uma letra: ")
      leia(letra) letra = txt.caixa_alta(letra)
      
      se (txt.numero_caracteres(letra) > 0) { letra = txt.extrair_subtexto(letra, 0, 1) }

      logico achou_letra = falso

      para (inteiro i = 0; i < tamanho; i++) {
        cadeia letra_atual = txt.extrair_subtexto(palavra_secreta, i, i + 1)
        se (letra == letra_atual e revelado[i] == "_") { revelado[i] = letra acertos++ achou_letra = verdadeiro }
      }
      se (achou_letra == falso) { erros++ }
    }

    limpa()
    escreva("--- FIM DO JOGO ---\n\n")
    se (acertos == tamanho) { escreva("=================================\nVocê VENCEU! A palavra era: ", palavra_secreta, "\n=================================\n") } 
    senao { escreva(" +---+\n |   |\n |   O\n |  /|\\\n |  / \\\n |\n=========\n\nVocê PERDEU! A palavra correta era: ", palavra_secreta, "\n") }
    escreva("\nPressione ENTER para voltar ao menu de jogos...") leia(pausa)
  }

  funcao jogo_jokenpo()
  {
    inteiro esc_j, esc_pc
    cadeia nomes[3] = {"Pedra", "Papel", "Tesoura"}, pausa
    limpa() escreva("--- JOKENPÔ ---\n1. Pedra\n2. Papel\n3. Tesoura\nEscolha: ") leia(esc_j)
    se (esc_j >= 1 e esc_j <= 3) {
      esc_pc = u.sorteia(1, 3)
      escreva("\nVocê: ", nomes[esc_j-1], " x PC: ", nomes[esc_pc-1], "\n")
      se (esc_j == esc_pc) { escreva(">> EMPATE! <<\n") }
      senao se ((esc_j==1 e esc_pc==3) ou (esc_j==2 e esc_pc==1) ou (esc_j==3 e esc_pc==2)) { escreva(">> VOCÊ VENCEU! <<\n") } 
      senao { escreva(">> PC VENCEU! <<\n") }
    } senao { escreva("\n[!] Inválido.\n") }
    escreva("\nPressione ENTER para voltar...") leia(pausa)
  }

  funcao add_q(cadeia perg, cadeia op1, cadeia op2, cadeia op3, inteiro gab)
  {
    se (total_bd_quiz < 200) {
      quiz_perguntas[total_bd_quiz] = perg quiz_opcoes[total_bd_quiz][0] = op1 quiz_opcoes[total_bd_quiz][1] = op2 quiz_opcoes[total_bd_quiz][2] = op3 quiz_gabarito[total_bd_quiz] = gab total_bd_quiz++
    }
  }

  funcao carregar_banco_quiz()
  {
    add_q("O que significa CPU?", "Central Processing Unit", "Computer Personal Unit", "Control Process Unit", 1)
    add_q("Qual componente armazena dados permanentemente?", "Memória RAM", "Processador", "Disco Rígido (HD/SSD)", 3)
    add_q("O que faz a placa-mãe?", "Gera energia", "Conecta os componentes", "Resfria o PC", 2)
    add_q("Qual a principal função da GPU?", "Processar gráficos", "Processar áudio", "Salvar arquivos", 1)
    add_q("O que significa RAM?", "Random Access Memory", "Read Access Memory", "Run All Memory", 1)
    add_q("Qual o sistema operacional mais usado em PCs desktop?", "Linux", "Windows", "MacOS", 2)
    add_q("O que significa a sigla WWW?", "World Wide Web", "World Web Wide", "Web World Wide", 1)
    add_q("Qual linguagem é muito usada para desenvolvimento web front-end?", "Python", "C++", "JavaScript", 3)
    add_q("O que é um IP?", "Identificador Pessoal", "Protocolo de Internet", "Interface de Programação", 2)
    add_q("Para que serve um compilador?", "Traduzir código para linguagem de máquina", "Criar imagens", "Limpar a memória", 1)
    add_q("O que é o Linux?", "Um navegador", "Um sistema operacional de código aberto", "Um antivírus", 2)
    add_q("O que é phishing?", "Tipo de memória RAM", "Ataque cibernético enganoso", "Programa de edição de texto", 2)
    add_q("Qual a unidade básica de informação na computação?", "Byte", "Bit", "Megabyte", 2)
    add_q("Quantos bits tem 1 Byte?", "8 bits", "16 bits", "4 bits", 1)
    add_q("Qual protocolo é usado para enviar emails?", "HTTP", "FTP", "SMTP", 3)
    add_q("O que significa HTML?", "HyperText Markup Language", "HighText Machine Language", "Hyperlink Text Mode Level", 1)
    add_q("O que é um algoritmo?", "Peça de hardware", "Sequência lógica de instruções", "Erro no sistema", 2)
    add_q("O que faz a tecla F5 na maioria dos navegadores?", "Fecha a aba", "Atualiza a página", "Abre as configurações", 2)
    add_q("O que é a nuvem (Cloud Computing)?", "Servidores na internet que armazenam dados", "Sistema de refrigeração do PC", "Programa de clima", 1)
    add_q("Qual o atalho padrão para COPIAR um arquivo no Windows?", "Ctrl + V", "Ctrl + X", "Ctrl + C", 3)
    add_q("Qual empresa criou o sistema operacional Android?", "Apple", "Google", "Microsoft", 2)
    add_q("O que é BIOS?", "Basic Input/Output System", "Binary Internal Operative System", "Base Internet Online Server", 1)
    add_q("Para que serve o comando PING em redes?", "Baixar arquivos", "Testar a conectividade", "Desligar o PC de outra pessoa", 2)
    add_q("O que é uma VPN?", "Virtual Private Network", "Vírus de Proteção Nacional", "Visual Processing Node", 1)
    add_q("Em que ano a World Wide Web (WWW) foi inventada?", "1989", "1995", "2000", 1)
    add_q("O que significa SQL?", "Structured Question Language", "System Query Level", "Structured Query Language", 3)
    add_q("Qual formato de arquivo é usado para documentos portáteis?", "TXT", "PDF", "EXE", 2)
    add_q("O que é um software de código aberto (Open Source)?", "Software pago", "Software com código acessível", "Software de fotos", 2)
    add_q("O que é um firewall?", "Barreira de segurança de rede", "Programa para acelerar internet", "Placa de vídeo antiga", 1)
    add_q("Qual dessas NÃO é uma linguagem de programação?", "Python", "Java", "HTML", 3)
    add_q("O que é um cavalo de troia (Trojan)?", "Processador rápido", "Programa malicioso disfarçado", "Tipo de teclado gamer", 2)
    add_q("O que é a Dark Web?", "Parte da internet não indexada", "Rede social para góticos", "Tema escuro do Windows", 1)
    add_q("O que significa a sigla USB?", "Universal Serial Bus", "United System Board", "Unified Storage Base", 1)
    add_q("Qual a função da fonte de alimentação em um PC?", "Fornecer internet", "Fornecer energia elétrica", "Gerar gráficos", 2)
    add_q("O que é um SSD?", "Super Speed Disk", "Solid State Drive", "System Storage Data", 2)
    add_q("Qual a principal diferença entre HDD e SSD?", "SSD usa discos", "SSD é mecânico", "SSD usa memória flash", 3)
    add_q("O que significa a sigla URL?", "Uniform Resource Locator", "Universal Routing Link", "User Reference Line", 1)
    add_q("Qual dessas portas é comumente usada para HTTP?", "Porta 80", "Porta 21", "Porta 443", 1)
    add_q("Qual dessas portas é comumente usada para HTTPS?", "Porta 80", "Porta 21", "Porta 443", 3)
    add_q("O que faz o comando Ctrl + Z?", "Salva o arquivo", "Desfaz a última ação", "Imprime o documento", 2)
    add_q("O que é um endereço MAC?", "Identificador físico de rede", "Site da Apple", "Protocolo de e-mail", 1)
    add_q("O que é overclock?", "Aumentar a velocidade do clock do hardware", "Tela de descanso", "Mudar a hora", 1)
    add_q("Qual a função do DNS?", "Proteger contra vírus", "Traduzir domínios em IPs", "Acelerar downloads", 2)
    add_q("O que é um Bug em software?", "Uma falha ou erro no código", "Um recurso novo", "Um tipo de arquivo", 1)
    add_q("O que é Inteligência Artificial?", "Computador que conserta hardware", "Sistemas que simulam aprendizado", "Programa de edição", 2)
    add_q("Qual o nome do criador do sistema operacional Linux?", "Bill Gates", "Linus Torvalds", "Steve Jobs", 2)
    add_q("O que é criptografia?", "Ocultar dados codificando a informação", "Baixar arquivos ilegalmente", "Excluir arquivos", 1)
    add_q("Qual tecla entra no modo de tela cheia na maioria dos navegadores?", "F11", "F5", "Esc", 1)
    add_q("O que é um Pixel?", "Menor elemento de uma imagem digital", "Marca de processador", "Um cabo de rede", 1)
    add_q("Qual a função do comando 'ipconfig' no Windows?", "Limpar a lixeira", "Mostrar configurações de IP", "Formatar o disco C:", 2)
  }

  funcao jogo_quiz_avancado()
  {
    limpa()
    escreva("--- QUIZ DE INFORMÁTICA AVANÇADO ---\nSerão sorteadas 20 para você.\n")
    se (cheat_quiz) { escreva("[MODO DEUS ON] Gabaritos visíveis.\n") }
    escreva("\nPressione ENTER para começar...") cadeia pausa leia(pausa)

    inteiro sorteadas[20], qtd_sorteadas = 0

    enquanto (qtd_sorteadas < 20) {
      inteiro indice = u.sorteia(0, total_bd_quiz - 1) logico repetido = falso
      para (inteiro i = 0; i < qtd_sorteadas; i++) { se (sorteadas[i] == indice) { repetido = verdadeiro pare } }
      se (repetido == falso) { sorteadas[qtd_sorteadas] = indice qtd_sorteadas++ }
    }

    inteiro pontos = 0, resposta

    para (inteiro i = 0; i < 20; i++)
    {
      limpa() inteiro id_pergunta = sorteadas[i]

      escreva("--- PERGUNTA ", i + 1, " DE 20 ---\n\n")
      escreva(quiz_perguntas[id_pergunta], "\n\n")
      
      se (cheat_quiz) { escreva(" [HACK] A resposta certa é a opção: ", quiz_gabarito[id_pergunta], "\n\n") }

      escreva(" [1] ", quiz_opcoes[id_pergunta][0], "\n [2] ", quiz_opcoes[id_pergunta][1], "\n [3] ", quiz_opcoes[id_pergunta][2], "\n\nSua resposta (1, 2 ou 3): ")
      leia(resposta)

      se (resposta == quiz_gabarito[id_pergunta]) { escreva("\n -> CORRETO! Excelente.\n") pontos++ } senao { escreva("\n -> ERRADO! A resposta certa era a [", quiz_gabarito[id_pergunta], "].\n") }
      u.aguarde(2000)
    }

    limpa()
    escreva("====================================\n             FIM DO QUIZ!           \n====================================\n Você acertou ", pontos, " de 20 perguntas.\n\n")
    se (pontos == 20) { escreva(" INACREDITÁVEL! Você gabaritou, é um Deus da Informática!\n") } senao se (pontos >= 15) { escreva(" Excelente! Seu conhecimento é muito avançado.\n") } senao se (pontos >= 10) { escreva(" Muito bom! Você manja do assunto.\n") } senao { escreva(" Precisa estudar mais o manual do PortugOS!\n") }
    escreva("====================================\n\nPressione ENTER para voltar ao menu de jogos...") leia(pausa)
  }
}