from faker import Faker

fake = Faker("pt_BR")

def get_name():
    return fake.name()

def get_email():
    return fake.email()

def get_password():
    return fake.password(length=8)

def get_product_name():
    return fake.bs()

def get_product_price():
    return  fake.building_number()

def get_product_description():
    return fake.catch_phrase()

def get_product_quantity():
    return fake.day_of_month()