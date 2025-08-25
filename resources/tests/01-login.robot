*** Settings ***
Resource    ../keywords/01-login_keywords.resource


Test Setup    Criar Sessão

*** Test Cases ***

TC01 - Realizar Login com Sucesso Usuário Admin True
    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    Verificar se o login foi realizado com sucesso

TC02 - Realizar Login com e-mail inválido
    Realizar o login e Capturar o Token    ${EMAIL_MASTER}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message    Email e/ou senha inválidos

TC03 - Realizar login com e-mail em branco
    Realizar o login e Capturar o Token    ${EMAIL_EMPTY}    ${PASSWORD_MASTER}    400
    Verificar mensagem de erro ao ocorrer falha no login    email    email não pode ficar em branco

TC04 - Realizar login com a senha inválida
    Realizar o login e Capturar o Token    ${EMAIL_MASTER}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message        Email e/ou senha inválidos

TC05 - Realizar login com a senha em branco
    Realizar o login e Capturar o Token    ${EMAIL_MASTER}    ${PASSWORD_EMPTY}    400
    Verificar mensagem de erro ao ocorrer falha no login    password    password não pode ficar em branco

TC06 - Realizar login com e-mail e senha inválidos
    Realizar o login e Capturar o Token    ${EMAIL_INVALID}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message    Email e/ou senha inválidos

TC07 - Realizar login com e-mail e senha em branco
    Realizar o login e Capturar o Token    ${EMAIL_EMPTY}    ${PASSWORD_EMPTY}    400
    Verificar mensagem de erro ao ocorrer falha no login    email    email não pode ficar em branco
    Verificar mensagem de erro ao ocorrer falha no login    password    password não pode ficar em branco