from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship
from .config import Base

class Persona(Base):
    __tablename__ = 'personas'

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, nullable=False)
    edad = Column(Integer, nullable=False)
    numeroControl = Column(String, unique=True, nullable=False)
    correo = Column(String, unique=True, nullable=False)
    estatus = Column(String, nullable=False, default="Autorizado")
    noIncidencias = Column(Integer, nullable=False, default=0)
    autos = relationship("Auto", back_populates="persona")

class Auto(Base):
    __tablename__ = 'autos'
    __table_args__ = (UniqueConstraint('placa', name='uq_placa'),)

    id = Column(Integer, primary_key=True, index=True)
    marca = Column(String, nullable=False)
    modelo = Column(String, nullable=False)
    color = Column(String, nullable=False)
    placa = Column(String, nullable=False, unique=True, index=True)
    persona_id = Column(Integer, ForeignKey('personas.id', ondelete = "CASCADE"), nullable=False)

    persona = relationship("Persona", back_populates="autos")

class Incidencia(Base):
    __tablename__ = 'incidencias'

    id = Column(Integer, primary_key=True, index=True)
    descripcion = Column(String, nullable=False)
    fecha = Column(String, nullable=False)
    imagenes = Column(String, nullable=True) 
    persona_id = Column(Integer, ForeignKey('personas.id', ondelete = "CASCADE"), nullable=False)
    auto_id = Column(Integer, ForeignKey('autos.id', ondelete = "CASCADE"), nullable=False)

    persona = relationship("Persona", back_populates="incidencias")
    auto = relationship("Auto", back_populates="incidencias")

Persona.incidencias = relationship("Incidencia", back_populates="persona")
Auto.incidencias = relationship("Incidencia", back_populates="auto")