*** Settings ***

Resource    ../keywords/01-login_keywords.resource
Resource    ../keywords/02-usuarios_keywords.resource
Resource    ../pages/03-produtos.resource 
Resource    ../keywords/03-produtos.resource
Resource    ../keywords/04-carrinho.resource
Resource    ../pages/04-carrinho.resource

Library    ../../library/faker_api.py

Test Setup    Criar Sessão


*** Test Cases ***

TC01 - Cadastrar carrinho com sucesso
    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    ${NAME_ADMIN}      Get Name
    ${EMAIL_ADMIN}     Get Email
    ${PASSWORD_ADMIN}  Get Password

    Set Global Variable    ${NAME_ADMIN}
    Set Global Variable    ${EMAIL_ADMIN}
    Set Global Variable    ${PASSWORD_ADMIN}
    Cadastrar usuário    
    ...    ${NAME_ADMIN} 
    ...    ${EMAIL_ADMIN} 
    ...    ${PASSWORD_ADMIN} 
    ...    true
    ...    201
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${PRODUCT_NAME}    Get Product Name
    ${PRODUCT_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity

    Cadastrar produto    ${PRODUCT_NAME}    ${PRODUCT_PRICE}    ${PRODUCT_DESCRIPTION}    ${PRODUCT_QUANTITY}    ${TOKEN}     201
    Adicionar Produtos no Carrinho    ${PRODUCT_ID}    2    ${TOKEN}    201
    Verificar mensagem retornada    message    Cadastro realizado com sucesso

TC02 - Listar carrinho com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Listar todos os carrinhos
    Verificar os dados retornados da consulta de carrinho
    
TC03 - Buscar carrinho por id com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Buscar carrinho por id    ${CART_ID}    200
    Verificar os dados retornados da consulta de carrinho por id

# TC04 - Finalizar compra com sucesso

# TC05 - Cancelar compra e retornar produtos para o estoque

