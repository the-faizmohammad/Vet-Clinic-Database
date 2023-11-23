-- Insert data into the animals table
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES
('Agumon', '2020-02-03', 0, true, 10.23),
('Gabumon', '2018-11-15', 2, true, 8),
('Pikachu', '2021-01-07', 1, false, 15.04),
('Devimon', '2017-05-12', 5, true, 11);

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species) VALUES
('Charmander', '2020-02-08', 0, false, -11, 'unspecified'),
('Plantmon', '2021-11-15', 2, true, -5.7, 'unspecified'),
('Squirtle', '1993-04-02', 3, false, -12.13, 'unspecified'),
('Angemon', '2005-06-12', 1, true, -45, 'unspecified'),
('Boarmon', '2005-06-07', 7, true, 20.4, 'unspecified'),
('Blossom', '1998-10-13', 3, true, 17, 'unspecified'),
('Ditto', '2022-05-14', 4, true, 22, 'unspecified');

-- Multiples Tables

-- Insert data into the owners table
INSERT INTO owners (full_name, age) VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

-- Insert data into the species table
INSERT INTO species (name) VALUES
('Pokemon'),
('Digimon');

-- Modify inserted animals to include species_id and owner_id
UPDATE animals SET species_id = (CASE 
                                  WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
                                  ELSE (SELECT id FROM species WHERE name = 'Pokemon')
                                END);

UPDATE animals SET owner_id = (CASE
                                WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
                                WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
                                WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
                                WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
                                WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
                             END);

-- Join Tables Data

-- Insert data into the vets table
INSERT INTO vets (name, age, date_of_graduation) VALUES
('William Tatcher', 45, '2000-04-23'),
('Maisy Smith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harkness', 38, '2008-06-08');

-- Insert data into the specializations table
INSERT INTO specializations (vet_id, species_id) VALUES
(1, (SELECT id FROM species WHERE name = 'Pokemon')),
(3, (SELECT id FROM species WHERE name = 'Digimon')),
(3, (SELECT id FROM species WHERE name = 'Pokemon')),
(4, (SELECT id FROM species WHERE name = 'Digimon'));

-- Insert data into the visits table
INSERT INTO visits (animal_id, vet_id, visit_date) VALUES
-- Provided data for visits
(1, 1, '2020-05-24'),
(1, 3, '2020-07-22'),
(2, 4, '2021-02-02'),
(3, 2, '2020-01-05'),
(3, 2, '2020-03-08'),
(3, 2, '2020-05-14'),
(4, 3, '2021-05-04'),
(5, 4, '2021-02-24'),
(6, 3, '2020-05-24'),
(6, 1, '2021-01-11'),
(7, 2, '2022-05-14');
