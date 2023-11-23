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
-- Insert new data into the animals table
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species) VALUES
('Charmander', '2020-02-08', 0, false, -11, 'unspecified'),
('Plantmon', '2021-11-15', 2, true, -5.7, 'unspecified'),
('Squirtle', '1993-04-02', 3, false, -12.13, 'unspecified'),
('Angemon', '2005-06-12', 1, true, -45, 'unspecified'),
('Boarmon', '2005-06-07', 7, true, 20.4, 'unspecified'),
('Blossom', '1998-10-13', 3, true, 17, 'unspecified'),
('Ditto', '2022-05-14', 4, true, 22, 'unspecified');
