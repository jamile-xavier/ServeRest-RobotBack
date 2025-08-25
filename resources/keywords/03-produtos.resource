*** Settings ***
Library    RequestsLibrary


*** Keywords ***

Cadastrar produto
    [Documentation]     Cadastro de produto
    [Arguments]    ${name}    ${price}    ${description}    ${quantity}    ${token}   ${expected_status_code}    
    ${body}    Create Dictionary
    ...    nome=${name}
    ...    preco=${price}
    ...    descricao=${description}
    ...    quantidade=${quantity}
    
    ${headers}    Create Dictionary    Authorization=${token}
    ${response}    POST On Session
    ...    alias=ServeRest
    ...    url=${PRODUCT}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=${expected_status_code}

    IF    ${expected_status_code} == 201
        Set Global Variable    ${PRODUCT_ID}    ${response.json()['_id']}
    END
    Set Test Variable    ${DATA}    ${response.json()}

Listar todos os produtos cadastrados
    [Documentation]    Listar todos os produtos cadastrados
    [Arguments]    ${expected_status_code}=200    ${query_params}=None    &{headers}   
    # Se headers não foi passado, inicializa vazio
    Run Keyword If    '${headers}' == ''    ${headers}=    Create Dictionary

    ${base_url}=    Set Variable    ${BASE_URL}${PRODUCT}

    IF    '${query_params}' != 'None'
        ${final_url}=    Set Variable    ${base_url}?${query_params}
    ELSE
        ${final_url}=    Set Variable    ${base_url}
    END

    Log    URL Final utilizada: ${final_url}

    ${response}=    GET On Session    alias=ServeRest    url=${final_url}    expected_status=${expected_status_code}    headers=${headers}
    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de produtos
    [Documentation]    Verificar dados retornados ao pesquisar produtos
    Dictionary Should Contain Key    ${DATA}    quantidade
    Dictionary Should Contain Key    ${DATA}    produtos
    ${length}    Get Length    ${DATA["produtos"]}
    Should Be True    ${length} > 0

Validar campos do produto
    [Documentation]    Validação dos campos retornados do produto
    FOR    ${produto}    IN    @{DATA["produtos"]}
        FOR    ${chave}    IN    nome    preco    descricao    quantidade    
            Dictionary Should Contain Key    ${produto}    ${chave}
        END
    END  

Buscar produto por id
    [Documentation]    Busca produto por id
    [Arguments]    ${expected_status_code}    ${id}
    ${response}    GET On Session    
    ...    alias=ServeRest 
    ...    url=${PRODUCT}/${id}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de produto por id
    [Documentation]    Verificar os dados retornados ao consultar um produto por id
    ${length}    Get Length    ${DATA}
    Should Be True    ${length} > 0
    Dictionary Should Contain Key    ${DATA}    nome
    Dictionary Should Contain Key    ${DATA}    preco
    Dictionary Should Contain Key    ${DATA}    descricao
    Dictionary Should Contain Key    ${DATA}    quantidade

Editar preco do produto
    [Documentation]    Edição de preço do produto
    [Arguments]    ${name}    ${price_update}    ${description}    ${quantity}    ${token}    ${expected_status_code}      
    ${headers}    Create Dictionary    Authorization=${token}     
    ${body}    Create Dictionary
    ...    nome=${name}
    ...    preco=${price_update}
    ...    descricao=${description}
    ...    quantidade=${quantity}
    ${response}    PUT On Session    
    ...    alias=ServeRest
    ...    url=${PRODUCT}/${PRODUCT_ID}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Excluir produto por id
    [Documentation]    Exclusão do produto pelo seu id
    [Arguments]    ${token}    ${expected_status_code}   
    ${headers}    Create Dictionary    Authorization=${token}  
    ${response}    DELETE On Session    
    ...    alias=ServeRest    
    ...    url=${PRODUCT}/${PRODUCT_ID}    
    ...    headers=${headers}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}