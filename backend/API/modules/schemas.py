from pydantic import BaseModel, EmailStr

class PersonaCreate(BaseModel):
    nombre: str
    edad: int
    numeroControl: str
    correo: EmailStr


class PersonaRead(BaseModel):
    id: int
    nombre: str
    edad: int
    numeroControl: str
    correo: EmailStr
    estatus: str | None = None
    noIncidencias: int | None = None

    class Config:
        from_attributes = True

class AutoCreate(BaseModel):
    placa: str
    marca: str
    modelo: str
    color: str


class AutoRead(BaseModel):
    id: int
    placa: str
    marca: str
    modelo: str
    color: str
    personaId: int

    class Config:
        orm_mode = True

class IncidenciaCreate(BaseModel):
    descripcion: str
    fecha: str
    imagenes: list[str] 
    personaId: int
    autoId: int

class IncidenciaRead(BaseModel):
    id: int
    descripcion: str
    fecha: str
    imagenes: list[str] 
    personaId: int
    autoId: int

    class Config:
        orm_mode = True
