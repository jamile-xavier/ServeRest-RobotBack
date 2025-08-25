*** Settings ***
Library    RequestsLibrary


*** Keywords ***

Adicionar Produtos no Carrinho
    [Documentation]    Adiciona múltiplos produtos ao carrinho
    [Arguments]    ${product_id}    ${quantity}   ${token}    ${expected_status_code}

    ${produto}    Create Dictionary
    ...    idProduto=${product_id}
    ...    quantidade=${quantity}

    ${produtos}    Create List    ${produto}
    ${body}    Create Dictionary    produtos=${produtos}

    ${headers}    Create Dictionary    Authorization=${token}

    ${response}    POST On Session
    ...    alias=ServeRest
    ...    url=${CART}
    ...    headers=${headers}
    ...    json=${body}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}
    Set Global Variable    ${CART_ID}    ${response.json()["_id"]}

Listar todos os carrinhos
    [Documentation]    Listar todos os carrinhos cadastrados
    [Arguments]    ${expected_status_code}=200    ${query_params}=None    &{headers}   
    # Se headers não foi passado, inicializa vazio
    Run Keyword If    '${headers}' == ''    ${headers}=    Create Dictionary

    ${base_url}=    Set Variable    ${BASE_URL}${CART}

    IF    '${query_params}' != 'None'
        ${final_url}=    Set Variable    ${base_url}?${query_params}
    ELSE
        ${final_url}=    Set Variable    ${base_url}
    END

    Log    URL Final utilizada: ${final_url}

    ${response}=    GET On Session    alias=ServeRest    url=${final_url}    expected_status=${expected_status_code}    headers=${headers}
    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de carrinho
    [Documentation]    Verificar dados retornados ao pesquisar produtos
    Dictionary Should Contain Key    ${DATA}    quantidade
    Dictionary Should Contain Key    ${DATA}    carrinhos

    # Percorre todos os carrinhos
    FOR    ${carrinho}    IN    @{DATA["carrinhos"]}
        Dictionary Should Contain Key    ${carrinho}    produtos
        Dictionary Should Contain Key    ${carrinho}    precoTotal
        Dictionary Should Contain Key    ${carrinho}    quantidadeTotal
        Dictionary Should Contain Key    ${carrinho}    idUsuario
        Dictionary Should Contain Key    ${carrinho}    _id

        ${length}    Get Length    ${carrinho["produtos"]}
        Should Be True    ${length} > 0

        # Agora percorre todos os produtos do carrinho
        FOR    ${produto}    IN    @{carrinho["produtos"]}
            Dictionary Should Contain Key    ${produto}    idProduto
            Dictionary Should Contain Key    ${produto}    quantidade
            Dictionary Should Contain Key    ${produto}    precoUnitario

            # Validações extras (exemplo)
            Should Be True    ${produto["quantidade"]} > 0
            Should Be True    ${produto["precoUnitario"]} > 0
        END
    END

Buscar carrinho por id
    [Documentation]    Busca carrinho por id
    [Arguments]    ${id}    ${expected_status_code}
    ${response}    GET On Session    
    ...    alias=ServeRest 
    ...    url=${CART}/${id}
    ...    expected_status=${expected_status_code}

    Set Test Variable    ${DATA}    ${response.json()}

Verificar os dados retornados da consulta de carrinho por id
    [Documentation]    Verificar os dados retornados ao consultar um carrinho por id

    # Pega a lista de produtos do carrinho
    ${produtos}    Set Variable    ${DATA["produtos"]}

    FOR    ${produto}    IN    @{produtos}
        Dictionary Should Contain Key    ${produto}    idProduto
        Dictionary Should Contain Key    ${produto}    quantidade
        Dictionary Should Contain Key    ${produto}    precoUnitario

        # Validando valores
        Should Be True    ${produto["quantidade"]} > 0
        Should Be True    ${produto["precoUnitario"]} > 0
    END

# Editar preco do produto
#     [Documentation]    Edição de preço do produto
#     [Arguments]    ${name}    ${price_update}    ${description}    ${quantity}    ${token}    ${expected_status_code}      
#     ${headers}    Create Dictionary    Authorization=${token}     
#     ${body}    Create Dictionary
#     ...    nome=${name}
#     ...    preco=${price_update}
#     ...    descricao=${description}
#     ...    quantidade=${quantity}
#     ${response}    PUT On Session    
#     ...    alias=ServeRest
#     ...    url=${PRODUCT}/${PRODUCT_ID}
#     ...    headers=${headers}
#     ...    json=${body}
#     ...    expected_status=${expected_status_code}

#     Set Test Variable    ${DATA}    ${response.json()}

# Excluir produto por id
#     [Documentation]    Exclusão do produto pelo seu id
#     [Arguments]    ${token}    ${expected_status_code}   
#     ${headers}    Create Dictionary    Authorization=${token}  
#     ${response}    DELETE On Session    
#     ...    alias=ServeRest    
#     ...    url=${PRODUCT}/${PRODUCT_ID}    
#     ...    headers=${headers}
#     ...    expected_status=${expected_status_code}

#     Set Test Variable    ${DATA}    ${response.json()}