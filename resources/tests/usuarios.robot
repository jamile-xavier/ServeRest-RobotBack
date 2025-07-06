*** Settings ***
Resource    ../keywords/login_keywords.resource
Resource    ../pages/login_variables.resource
Resource    ../keywords/usuarios_keywords.resource

Library    FakerLibrary    locale=pt_BR

Test Setup    Criar Sessão

*** Test Cases ***
TC01 - Cadastrar usuário admin true com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Cadastrar usuário    
    ...    ${NAME_USER} 
    ...    ${EMAIL_USER} 
    ...    ${PASSWORD_USER} 
    ...    true
    ...    201
    Verificar se o cadastro foi concluído com sucesso  
  