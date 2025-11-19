from fastapi import FastAPI, HTTPException
from .config import Base, engine, SessionLocal
from .models import Auto, Persona

app = FastAPI(title="API Placas", version="1.0.0")

@app.on_event("startup")
def crear_tablas():
    Base.metadata.create_all(bind=engine)


@app.get("/autos/placa/{placa}")
def buscar_auto_por_placa(placa):
    db = SessionLocal()
    try:
        consulta = db.query(Auto).join(Persona).filter(Auto.placa == placa).first()

        if not consulta:
            raise HTTPException(status_code=404, detail="Placa no registrada")

        respuesta = {
            "auto": {
                "id": consulta.id,
                "placa": consulta.placa,
                "marca": consulta.marca,
                "modelo": consulta.modelo,
                "color": consulta.color,
            },
            "persona": {
                "id": consulta.persona.id,
                "nombre": consulta.persona.nombre,
                "apellido": consulta.persona.apellido,
            },
        }
        return respuesta
    finally:
        db.close()
