*** Settings ***
Resource    ../keywords/login.resource


Test Setup    Criar Sessão

*** Test Cases ***

TC01 - Realizar Login com Sucesso Usuário Admin True
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Verificar se o login foi realizado com sucesso

TC02 - Realizar Login com Sucesso Usuário Admin False
    Realizar o login e capturar o token    ${EMAIL_USER}    ${PASSWORD_USER}    200
    Verificar se o login foi realizado com sucesso    

TC03 - Realizar Login com e-mail inválido
    Realizar o login e Capturar o Token    ${EMAIL_ADMIN}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message    Email e/ou senha inválidos

TC04 - Realizar login com e-mail em branco
    Realizar o login e Capturar o Token    ${EMAIL_EMPTY}    ${PASSWORD_ADMIN}    400
    Verificar mensagem de erro ao ocorrer falha no login    email    email não pode ficar em branco

TC05 - Realizar login com a senha inválida
    Realizar o login e Capturar o Token    ${EMAIL_ADMIN}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message        Email e/ou senha inválidos

TC06 - Realizar login com a senha em branco
    Realizar o login e Capturar o Token    ${EMAIL_ADMIN}    ${EMAIL_EMPTY}    400
    Verificar mensagem de erro ao ocorrer falha no login    password    password não pode ficar em branco

TC07 - Realizar login com e-mail e senha inválidos
    Realizar o login e Capturar o Token    ${EMAIL_INVALID}    ${PASSWORD_INVALID}    401
    Verificar mensagem de erro ao ocorrer falha no login    message    Email e/ou senha inválidos

TC08 - Realizar login com e-mail e senha em branco
    Realizar o login e Capturar o Token    ${EMAIL_EMPTY}    ${PASSWORD_EMPTY}    400
    Verificar mensagem de erro ao ocorrer falha no login    email    email não pode ficar em branco
    Verificar mensagem de erro ao ocorrer falha no login    password    password não pode ficar em branco