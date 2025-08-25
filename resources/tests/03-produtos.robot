*** Settings ***

Resource    ../keywords/01-login_keywords.resource
Resource    ../keywords/02-usuarios_keywords.resource
Resource    ../pages/03-produtos.resource 
Resource    ../keywords/03-produtos.resource

Library    ../../library/faker_api.py

Test Setup    Criar Sessão


*** Test Cases ***

TC01 - Cadastrar produto com usuário admin com sucesso
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
    Verificar mensagem retornada    message    Cadastro realizado com sucesso

TC02 - Listar produtos com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Listar todos os produtos cadastrados
    Verificar os dados retornados da consulta de produtos
    Validar campos do produto

TC03 - Buscar produto por id com sucesso
    Buscar produto por id    200    ${PRODUCT_ID} 
    Verificar os dados retornados da consulta de produto por id

TC04 - Atualizar produto com usuário admin com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${PRODUCT_NAME}    Get Product Name
    ${NEW_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity
    Set Global Variable    ${NEW_PRICE} 
    Editar preco do produto    
    ...    ${PRODUCT_NAME} 
    ...    ${NEW_PRICE}
    ...    ${PRODUCT_DESCRIPTION}
    ...    ${PRODUCT_QUANTITY}
    ...    ${TOKEN}
    ...    200
    Verificar mensagem retornada    message   Registro alterado com sucesso

TC05 - Excluir produto com usuário admin com sucesso
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Excluir produto por id    ${TOKEN}    200
    Verificar mensagem retornada    message    Registro excluído com sucesso 

TC06 - Cadastrar produto com nome em duplicidade
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${PRODUCT_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity

    Cadastrar produto    ${PRODUCT_NAME_DUPLICATE}     ${PRODUCT_PRICE}    ${PRODUCT_DESCRIPTION}    ${PRODUCT_QUANTITY}    ${TOKEN}     400

    Verificar mensagem retornada    message  Já existe produto com esse nome

TC07 - Cadastrar produto sem informar o token
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${PRODUCT_NAME}    Get Product Name
    ${PRODUCT_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity

    Cadastrar produto    ${PRODUCT_NAME_DUPLICATE}     ${PRODUCT_PRICE}    ${PRODUCT_DESCRIPTION}    ${PRODUCT_QUANTITY}    ${TOKEN_BLANK}    401
    Verificar mensagem retornada    message  Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

TC08 - Listar produtos utilizando preco inválido por query
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Listar todos os produtos cadastrados    400    query_params=preco=-1
    Verificar mensagem retornada    preco    preco deve ser um número positivo 
    
TC09 - Listar produtos utilizando quantidade inválida por query
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Listar todos os produtos cadastrados    400    query_params=quantidade=-25
    Verificar mensagem retornada    quantidade    quantidade deve ser maior ou igual a 0        

TC10 - Atualizar produto sem informar um token
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    ${PRODUCT_NAME}    Get Product Name
    ${NEW_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity
    Set Global Variable    ${NEW_PRICE} 
    Editar preco do produto    
    ...    ${PRODUCT_NAME} 
    ...    ${NEW_PRICE}
    ...    ${PRODUCT_DESCRIPTION}
    ...    ${PRODUCT_QUANTITY}
    ...    ${TOKEN_BLANK}
    ...    401
    Verificar mensagem retornada    message   Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

TC11 - Excluir produto sem informar um token
    Realizar o login e capturar o token   ${EMAIL_ADMIN}    ${PASSWORD_ADMIN}    200
    Excluir produto por id    ${TOKEN_BLANK}    401
    Verificar mensagem retornada    message    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

TC12 - Cadastrar produto com usuário admin false
    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    ${NAME_USER}      Get Name
    ${EMAIL_USER}     Get Email
    ${PASSWORD_USER}  Get Password

    Set Global Variable    ${NAME_USER}
    Set Global Variable    ${EMAIL_USER}
    Set Global Variable    ${PASSWORD_USER}
    Cadastrar usuário    
    ...    ${NAME_USER} 
    ...    ${EMAIL_USER} 
    ...    ${PASSWORD_USER} 
    ...    false
    ...    201
    Realizar o login e capturar o token   ${EMAIL_USER}    ${PASSWORD_USER}    200
    ${PRODUCT_NAME}    Get Product Name
    ${PRODUCT_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity

    Cadastrar produto    ${PRODUCT_NAME}    ${PRODUCT_PRICE}    ${PRODUCT_DESCRIPTION}    ${PRODUCT_QUANTITY}    ${TOKEN}     403
    Verificar mensagem retornada    message    Rota exclusiva para administradores

TC13 - Atualizar produto com token de usuário admin false
    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    ${NAME_USER}      Get Name
    ${EMAIL_USER}     Get Email
    ${PASSWORD_USER}  Get Password

    Set Global Variable    ${NAME_USER}
    Set Global Variable    ${EMAIL_USER}
    Set Global Variable    ${PASSWORD_USER}
    Cadastrar usuário    
    ...    ${NAME_USER} 
    ...    ${EMAIL_USER} 
    ...    ${PASSWORD_USER} 
    ...    false
    ...    201
    Realizar o login e capturar o token   ${EMAIL_USER}    ${PASSWORD_USER}    200
    ${PRODUCT_NAME}    Get Product Name
    ${NEW_PRICE}    Get Product Price
    ${PRODUCT_DESCRIPTION}    Get Product Description
    ${PRODUCT_QUANTITY}    Get Product Quantity
    Set Global Variable    ${NEW_PRICE} 
    Editar preco do produto    
    ...    ${PRODUCT_NAME} 
    ...    ${NEW_PRICE}
    ...    ${PRODUCT_DESCRIPTION}
    ...    ${PRODUCT_QUANTITY}
    ...    ${TOKEN}
    ...    403
    Verificar mensagem retornada    message   Rota exclusiva para administradores

TC14 - Excluir produto com usuário admin false
    Realizar o login e capturar o token   ${EMAIL_MASTER}    ${PASSWORD_MASTER}    200
    ${NAME_USER}      Get Name
    ${EMAIL_USER}     Get Email
    ${PASSWORD_USER}  Get Password

    Set Global Variable    ${NAME_USER}
    Set Global Variable    ${EMAIL_USER}
    Set Global Variable    ${PASSWORD_USER}
    Cadastrar usuário    
    ...    ${NAME_USER} 
    ...    ${EMAIL_USER} 
    ...    ${PASSWORD_USER} 
    ...    false
    ...    201
    Realizar o login e capturar o token   ${EMAIL_USER}    ${PASSWORD_USER}    200
    Excluir produto por id    ${TOKEN}    403
    Verificar mensagem retornada    message    Rota exclusiva para administradores