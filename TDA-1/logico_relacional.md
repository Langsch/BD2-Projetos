# Projeto Lógico

## Eleição
- **ID**: int (PK)
- **Nome**: string
- **Ano**: int

## Candidato
- **Matricula**: int (PK)
- **Nome**: string
- **DataNascimento**: date
- **CPF**: string
- **RG**: string
- **CargoID**: int (FK)

## Cargo
- **ID**: int (PK)
- **Nome**: string

## Eleitor
- **TituloEleitor**: int (PK)
- **Nome**: string
- **CPF**: string
- **RG**: string
- **ZonaID**: int (FK)
- **SecaoID**: int (FK)

## Mesário
- **ID**: int (PK)
- **EleitorID**: int (FK)
- **ZonaID**: int (FK)
- **SecaoID**: int (FK)

## Zona
- **ID**: int (PK)
- **Nome**: string

## Seção
- **ID**: int (PK)
- **Nome**: string
- **ZonaID**: int (FK)

## Voto
- **ID**: int (PK)
- **EleicaoID**: int (FK)
- **SecaoID**: int (FK)
- **CandidatoID**: int (FK)
- **TipoVoto**: string (Valores: Branco, Nulo,
