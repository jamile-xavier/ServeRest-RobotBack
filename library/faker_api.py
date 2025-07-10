from faker import Faker

fake = Faker("pt_BR")

def get_name():
    return fake.name()

def get_email():
    return fake.email()

def get_password():
    return fake.password(length=8)