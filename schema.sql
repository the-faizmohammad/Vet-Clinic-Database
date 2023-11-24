CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL
);
-- Add a new column 'species' to the animals table

ALTER TABLE animals ADD COLUMN species VARCHAR(255);


-- Multiples Tables

-- Create the owners table
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

-- Create the species table
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- Modify the animals table
ALTER TABLE animals
    ADD COLUMN species_id INTEGER,
    ADD COLUMN owner_id INTEGER,
    DROP COLUMN species,
    ADD FOREIGN KEY (species_id) REFERENCES species(id),
    ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

-- Join Tables Schema

-- Create the vets table
CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER,
    date_of_graduation DATE
);

-- Create the specializations table (join table for species and vets)
CREATE TABLE specializations (
    vet_id INTEGER,
    species_id INTEGER,
    PRIMARY KEY (vet_id, species_id),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id)
);


-- Create the visits table (join table for animals and vets)
CREATE TABLE visits (
    vet_id INTEGER,
    animal_id INTEGER,
    visit_date DATE,
    PRIMARY KEY (vet_id, animal_id, visit_date),
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (animal_id) REFERENCES animals(id)
);

