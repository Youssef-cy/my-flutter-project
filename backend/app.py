import bcrypt
from sqlalchemy import create_engine, Column, Integer, String, Identity
from sqlalchemy.orm import declarative_base, sessionmaker

# === SQLAlchemy Engine ===
engine = create_engine("sqlite:///employees.db", echo=True)

# === ORM Base ===
Base = declarative_base()

# === Define ORM Model ===
class Employee(Base):
    __tablename__ = "employees"

    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(50))
    market_name = Column(String(50))
    password = Column(String(255))

    def __repr__(self):
        return f"<Employee(id={self.id}, name='{self.name}', password = '{self.password}')>"

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "market_name": self.market_name,
            "pass": self.password
        }

    def set_password(self, password):
        salt = bcrypt.gensalt()
        self.password = bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

    def check_password(self, password):
        return bcrypt.checkpw(password.encode('utf-8'), self.password.encode('utf-8'))


# === Session ===
Session = sessionmaker(bind=engine)
session = Session()

# === Functions ===
def addemp(id, name, market_name, raw_password):
    new_employee = Employee(id=id, name=name, market_name=market_name)
    new_employee.set_password(raw_password)
    session.add(new_employee)
    session.commit()
    session.close()

def view_emp_by_id(id):
    emp  = session.query(Employee).filter_by(id=id).first()
    session.close()
    return emp

def logingin(name, market, hpassword):
    emp = session.query(Employee).filter_by(name=name, market_name=market).first()
    if emp:
        if emp.check_password(hpassword):
            print(f"Login successful for employee: {emp.name}")
            return 200
        else:
            print("Login failed. Invalid credentials.")
            return 401
    else:
        print("Login failed. Employee not found.")
        return 404

def signingup(name, market_name, raw_password):
    emp = session.query(Employee).filter_by(name=name, market_name=market_name).first()
    if emp:
        print(f"Employee {name} already exists.")
        return 202
    else:
        new_employee = Employee(name=name, market_name=market_name)
        new_employee.set_password(raw_password)
        session.add(new_employee)
        session.commit()
        print(f"Employee {name} added successfully.")
    session.close()
    return 201

# === Main Execution ===
if __name__ == "__main__":
    ...
    # Base.metadata.drop_all(engine)  # This is just a placeholder to avoid running the code when imported
    # Base.metadata.create_all(engine)  # This is just a placeholder to avoid running the code when imported
    # addemp(1, "John Doe", "Market A", "password123")
    # addemp(2, "Jane Smith", "Market B", "securepassword456")
    # logingin("John Doe", "Market A", "password123")
    # signingup("Alice Johnson", "Market C", "newpassword789")
