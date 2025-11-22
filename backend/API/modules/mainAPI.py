from fastapi import FastAPI, HTTPException
from .config import Base, engine, SessionLocal
from .models import Auto, Persona

app = FastAPI(title="API Placas", version="1.0.0")

@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)
    cargar_datos_iniciales()

def cargar_datos_iniciales():
    db = SessionLocal()
    try:
        if db.query(Persona).first():
            print("Datos ya cargados.")
            return

        datos = [
            {
                "persona": {
                    "nombre": "Juan",
                    "edad": 30,
                    "numeroControl": "123456",
                    "correo": "juan@example.com",
                },
                "auto": {
                    "placa": "A00-AAA",
                    "marca": "Nissan",
                    "modelo": "Sentra",
                    "color": "Rojo",
                },
            },
            {
                "persona": {
                    "nombre": "Ana",
                    "edad": 28,
                    "numeroControl": "654321",
                    "correo": "ana@example.com",
                },
                "auto": {
                    "placa": "NA-86-83",
                    "marca": "Toyota",
                    "modelo": "Corolla",
                    "color": "Azul",
                },
            },
            {
                "persona": {
                    "nombre": "Carlos",
                    "edad": 40,
                    "numeroControl": "112233",
                    "correo": "carlos@example.com",
                },
                "auto": {
                    "placa": "BBB222",
                    "marca": "Honda",
                    "modelo": "Civic",
                    "color": "Negro",
                },
            },
        ]

        for item in datos:
            persona = Persona(**item["persona"])
            db.add(persona)
            db.commit()
            db.refresh(persona)

            auto = Auto(**item["auto"], persona_id=persona.id)
            db.add(auto)
            db.commit()
    finally:
        db.close()

@app.get("/autos/placa/{placa}")
def buscar_datos_por_placa(placa):
    db = SessionLocal()
    try:
        consulta = db.query(Auto).join(Persona).filter(Auto.placa == placa).first()

        if not consulta:
            raise HTTPException(status_code=404, detail="Placa no registrada")

        respuesta = {
            "persona": {
                "nombre": consulta.persona.nombre,
                "edad": consulta.persona.edad,
                "correo": consulta.persona.correo,
            },
            "auto": {
                "placa": consulta.placa,
                "marca": consulta.marca,
                "modelo": consulta.modelo,
                "color": consulta.color,
            }
        }
        return respuesta
    finally:
        db.close()
        
