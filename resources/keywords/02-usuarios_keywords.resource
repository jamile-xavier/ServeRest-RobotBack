*** Settings ***
Resource    ../pages/02-usuarios_variables.resource
Resource    ../pages/01-login_variables.resource

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
    Set Global Variable    ${USER_EMAIL}    ${email}
    Set Global Variable    ${USER_PASSWORD}    ${password}

    IF    '${admin}' == 'true'
        Set Global Variable    ${ADMIN_EMAIL}    ${email}
        Set Global Variable    ${ADMIN_PASSWORD}    ${password}
    END
    END
    
     Set Test Variable    ${DATA}    ${response.json()}

Verificar mensagem retornada 
    [Documentation]    Verificar mensagem de retorno
    [Arguments]   ${message}     ${text_message}   
    Dictionary Should Contain Item    ${DATA}    ${message}    ${text_message}     

Verificar se contém o id na resposta
    Dictionary Should Contain Key    ${DATA}    _id

Listar todos os usuários cadastrados
    [Documentation]    Listar todos os usuários cadastrados
    [Arguments]    ${expected_status_code}=200    ${query_params}=None    &{headers}

    # Se headers não foi passado, inicializa vazio
    Run Keyword If    '${headers}' == ''    ${headers}=    Create Dictionary

    ${base_url}=    Set Variable    ${BASE_URL}${USER}

    IF    '${query_params}' != 'None'
        ${final_url}=    Set Variable    ${base_url}?${query_params}
    ELSE
        ${final_url}=    Set Variable    ${base_url}
    END

    Log    URL Final utilizada: ${final_url}

    ${response}=    GET On Session    alias=ServeRest    url=${final_url}    expected_status=${expected_status_code}    headers=${headers}
    Set Test Variable    ${DATA}    ${response.json()}


Verificar os dados retornados da consulta de usuários
    [Documentation]    Verificar dados retornados ao pesquisar usuários
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
    [Documentation]    Validação dos campos retornados do usuário
    FOR    ${usuario}    IN    @{DATA["usuarios"]}
        FOR    ${chave}    IN    nome    email    password    administrador    _id
            Dictionary Should Contain Key    ${usuario}    ${chave}
        END
    END    
    
Buscar usuário por id
    [Documentation]    Busca usuário por id
    [Arguments]    ${expected_status_code}    ${id}
    ${response}    GET On Session    
    ...    alias=ServeRest 
    ...    url=${USER}/${id}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de usuário por id
    [Documentation]    Verificar os dados retornados ao consultar um usuário por id
    ${length}    Get Length    ${DATA}
    Should Be True    ${length} > 0
    Dictionary Should Contain Key    ${DATA}    nome
    Dictionary Should Contain Key    ${DATA}    email
    Dictionary Should Contain Key    ${DATA}    password
    Dictionary Should Contain Key    ${DATA}    administrador
    Dictionary Should Contain Key    ${DATA}    _id  

Editar e-mail do usuário
    [Documentation]    Edição de e-mail
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
    [Documentation]    Exclusão do usuário pelo seu id
    [Arguments]    ${expected_status_code}    
    ${response}    DELETE On Session    
    ...    alias=ServeRest    
    ...    url=${USER}/${USER_ID}    
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

 Listar usuários true ou false
    [Documentation]     Busca de usuário admin true e false
    [Arguments]    ${expected_status_code}    ${is_admin}
    &{params}=    Create Dictionary    administrador    ${is_admin}
    ${response}=    GET On Session
    ...    alias=ServeRest
    ...    url=${USER}
    ...    params=${params}
    ...    expected_status=${expected_status_code}
    Set Test Variable    ${DATA}    ${response.json()}

Verificar o valor do campo administrador
    [Documentation]    Verifica o valor do campo administrador
    [Arguments]    ${esperado}
    FOR    ${usuario}    IN    @{DATA["usuarios"]}
       Should Be Equal    ${usuario["administrador"]}    ${esperado}
    END