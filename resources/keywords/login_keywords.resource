*** Settings ***

Resource    ../pages/login_variables.resource

Library    RequestsLibrary
Library    Collections

*** Keywords ***
Criar Sessão 
    [Documentation]    Criação de sessão inicial
    ${headers}    Create Dictionary    accept=application/json    Content-type=application/json
    Create Session    alias=ServeRest    url=${BASE_URL}


Realizar o login e capturar o token
    [Documentation]    Realizar login na ServeRest
    [Arguments]    ${email}    ${password}    ${expected_status_code}
    ${body}    Create Dictionary   
    ...     email=${email}    
    ...    password=${password}
    ${response}        POST On Session    
    ...    alias=ServeRest    
    ...    url=${LOGIN}    
    ...    json=${body}
    ...    expected_status=${expected_status_code}
    IF    ${expected_status_code} == 200
        Set Test Variable    ${TOKEN}    ${response.json()["authorization"]}
    END    
    
    Set Test Variable    ${DATA}    ${response.json()}

Verificar se o login foi realizado com sucesso
    [Documentation]    Verificar a mensagem de login realizado com sucesso
    Dictionary Should Contain Item       ${DATA}    message    Login realizado com sucesso 
    Dictionary Should Contain Item    ${DATA}       authorization    ${TOKEN}

Verificar mensagem de erro ao ocorrer falha no login
    [Arguments]   ${key}     ${msg_error}
     Dictionary Should Contain Item       ${DATA}    ${key}    ${msg_error}