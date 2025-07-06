*** Settings ***
Resource    ../pages/usuarios_variables.resource

Library    RequestsLibrary

*** Keywords ***
Cadastrar usuário
    [Documentation]    Realizar o cadastro de usuários
    [Arguments]  ${name}    ${email}    ${password}    ${admin}    ${expected_status_code}
    ${body}    Create Dictionary    
    ...    nome=${name}   
    ...    email=${email}   
    ...    password=${password}
    ...    administrador=${admin}

    ${response}    POST On Session
    ...    alias=ServeRest
    ...    url=${USER}
    ...    json=${body}
    ...    expected_status=${expected_status_code}
    IF    ${expected_status_code} == 201
        Set Test Variable    ${USER_ID}    ${response.json()["_id"]}
    END

    Set Test Variable    ${DATA}    ${response.json()}

Verificar se o cadastro foi concluído com sucesso      
    Dictionary Should Contain Item    ${DATA}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${DATA}    _id