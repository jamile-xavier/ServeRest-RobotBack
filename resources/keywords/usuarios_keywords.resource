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
        Set Global Variable    ${USER_ID}    ${response.json()["_id"]}
    END

    Set Test Variable    ${DATA}    ${response.json()}

Verificar mensagem retornada 
    [Arguments]    ${text_message}   
    Dictionary Should Contain Item    ${DATA}    message    ${text_message}     

Verificar se contém o id na resposta
    Dictionary Should Contain Key    ${DATA}    _id

Listar todos os usuários cadastrados
    [Arguments]    ${expected_status_code}
    ${response}    GET On Session    alias=ServeRest    url=${USER}    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de usuários
    Dictionary Should Contain Key    ${DATA}    quantidade
    Dictionary Should Contain Key    ${DATA}    usuarios
    ${length}    Get Length    ${DATA["usuarios"]}
    Should Be True    ${length} > 0
    # FOR    ${usuario}    IN    @{DATA["usuarios"]}
    # Dictionary Should Contain Key    ${usuario}    nome
    # Dictionary Should Contain Key    ${usuario}    email
    # Dictionary Should Contain Key    ${usuario}    password
    # Dictionary Should Contain Key    ${usuario}    administrador
    # Dictionary Should Contain Key    ${usuario}    _id  
    # END
Validar campos do usuário
    FOR    ${usuario}    IN    @{DATA["usuarios"]}
        FOR    ${chave}    IN    nome    email    password    administrador    _id
            Dictionary Should Contain Key    ${usuario}    ${chave}
        END
    END    
    
Buscar usuário por id
    [Arguments]    ${expected_status_code}
    ${response}    GET On Session    
    ...    alias=ServeRest 
    ...    url=${USER}/${USER_ID}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de usuário por id
    ${length}    Get Length    ${DATA}
    Should Be True    ${length} > 0
    Dictionary Should Contain Key    ${DATA}    nome
    Dictionary Should Contain Key    ${DATA}    email
    Dictionary Should Contain Key    ${DATA}    password
    Dictionary Should Contain Key    ${DATA}    administrador
    Dictionary Should Contain Key    ${DATA}    _id  

Editar e-mail do usuário
    [Arguments]    ${name}    ${email_update}  ${password}    ${admin}   ${expected_status_code}               
    ${body}    Create Dictionary   
    ...    nome=${name} 
    ...    email=${email_update}
    ...    password=${password}
    ...    administrador=${admin}
    ${response}    PUT On Session    
    ...    alias=ServeRest
    ...    url=${USER}/${USER_ID}
    ...    json=${body}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Excluir usuário por id
    [Arguments]    ${expected_status_code}    
    ${response}    DELETE On Session    
    ...    alias=ServeRest    
    ...    url=${USER}/${USER_ID}    
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

 Listar usuários true ou false
    [Arguments]    ${expected_status_code}    ${is_admin}
    &{params}=    Create Dictionary    administrador    ${is_admin}
    ${response}=    GET On Session
    ...    alias=ServeRest
    ...    url=${USER}
    ...    params=${params}
    ...    expected_status=${expected_status_code}
    Set Test Variable    ${DATA}    ${response.json()}

Verificar o valor do campo administrador
   [Arguments]    ${esperado}
    FOR    ${usuario}    IN    @{DATA["usuarios"]}
       Should Be Equal    ${usuario["administrador"]}    ${esperado}
    END