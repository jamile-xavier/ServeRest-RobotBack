*** Settings ***
Resource    ../keywords/login_keywords.resource
Resource    ../pages/login_variables.resource
Resource    ../keywords/usuarios_keywords.resource
Resource    ../pages/usuarios_variables.resource

Library    ../../library/faker_api.py

Test Setup    Criar Sessão

*** Test Cases ***
TC01 - Cadastrar usuário admin true com sucesso
    ${NAME_ADMIN}      Get Name
    ${EMAIL_ADMIN}     Get Email
    ${PASSWORD_ADMIN}  Get Password

    Set Global Variable    ${NAME_ADMIN}
    Set Global Variable    ${EMAIL_ADMIN}
    Set Global Variable    ${PASSWORD_ADMIN}

    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    Cadastrar usuário    
    ...    ${NAME_ADMIN} 
    ...    ${EMAIL_ADMIN} 
    ...    ${PASSWORD_ADMIN} 
    ...    true
    ...    201
    Verificar mensagem retornada  Cadastro realizado com sucesso
    Verificar se contém o id na resposta  
  
TC02 - Cadastrar usuário admin false com sucesso
    ${NAME_USER}      Get Name
    ${EMAIL_USER}     Get Email
    ${PASSWORD_USER}  Get Password

    Set Global Variable    ${NAME_USER}
    Set Global Variable    ${EMAIL_USER}
    Set Global Variable    ${PASSWORD_USER}

    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Cadastrar usuário    
    ...    ${NAME_USER} 
    ...    ${EMAIL_USER} 
    ...    ${PASSWORD_USER} 
    ...    false
    ...    201
    Verificar mensagem retornada  Cadastro realizado com sucesso
    Verificar se contém o id na resposta 

TC03 - Listar usuários cadastrados com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Listar todos os usuários cadastrados    200
    Verificar os dados retornados da consulta de usuários
    Validar campos do usuário

TC04 - Buscar usuário por id com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Buscar usuário por id    200
    Verificar os dados retornados da consulta de usuário por id
    
TC05 - Editar e-mail do usuário por id com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${NEW_EMAIL}    Get Email
    Set Global Variable    ${NEW_EMAIL} 
    Editar e-mail do usuário
    ...    ${NAME_ADMIN} 
    ...    ${NEW_EMAIL}
    ...    ${PASSWORD_ADMIN} 
    ...    true    
    ...    200
    Verificar mensagem retornada   Registro alterado com sucesso

TC06 - Excluir usuário por id com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Excluir usuário por id    200
    Verificar mensagem retornada    Registro excluído com sucesso 

TC07 - Listar usuários admin = true
    Listar usuários true ou false    200    true
    Verificar o valor do campo administrador    true
    Validar campos do usuário

TC08 - Listar usuários admin = false
    Listar usuários true ou false    200    false
    Verificar o valor do campo administrador    false
    Validar campos do usuário

TC09 - Cadastro de usuário com e-mail em duplicidade
    ${NAME_ADMIN}      Get Name
    ${PASSWORD_ADMIN}  Get Password

    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    Cadastrar usuário    
    ...    ${NAME_ADMIN} 
    ...    ${EMAIL_DUPLICATE} 
    ...    ${PASSWORD_ADMIN} 
    ...    true
    ...    400
    Verificar mensagem retornada  Este email já está sendo usado
    
#  TC10 - Listar usuários informando id inválido como query
     

# TC11 - Listar usuários informando e-mail inválido como query

# TC12 - Listar usuários informando senha inválida como query

# TC13 - BUscar usuários informando id inválido 

# TC14 - Atualizar usuário por id informando e-mail em duplicidade