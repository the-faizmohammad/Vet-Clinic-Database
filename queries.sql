-- Query 1
SELECT * FROM animals WHERE name LIKE '%mon';

-- Query 2
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- Query 3
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- Query 4
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- Query 5
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Query 6
SELECT * FROM animals WHERE neutered = true;

-- Query 7
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Query 8
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Transaction 1: Update species to 'unspecified' and roll back
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals; -- Verify the change
ROLLBACK;
SELECT * FROM animals; -- Verify rollback

-- Transaction 2: Update species based on conditions and commit
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals; -- Verify changes
COMMIT;
SELECT * FROM animals; -- Verify changes persist after commit

-- Transaction 3: Delete all records and roll back
BEGIN;
DELETE FROM animals;
SELECT * FROM animals; -- Verify deletion
ROLLBACK;
SELECT * FROM animals; -- Verify rollback

-- Transaction 4: Delete animals born after Jan 1, 2022, and update weights
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT weight_update;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO weight_update;
UPDATE animals SET weight_kg = ABS(weight_kg) WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals; -- Verify changes

-- Additional Queries

-- How many animals are there?
SELECT COUNT(*) FROM animals; 
-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals; 
-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
 -- Minimum and maximum weight of each type of animal
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
 -- Average escape attempts per animal type born between 1990 and 2000
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';

-- Multiples Tables

-- Query 9
SELECT * FROM animals
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- Query 10
SELECT * FROM animals
INNER JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- Query 11
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- Query 12
SELECT species.name, COUNT(*) as animal_count
FROM animals
INNER JOIN species ON animals.species_id = species.id
GROUP BY species.name;

-- Query 13
SELECT animals.name
FROM animals
INNER JOIN species ON animals.species_id = species.id
INNER JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- Query 14
SELECT animals.name
FROM animals
INNER JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

-- Query 15
SELECT owners.full_name, COUNT(animals.id) as animal_count
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- Join Table Query
-- Last animal seen by William Tatcher:
SELECT vets.name AS vet_name, animals.name AS animal_name, species.name AS species_name, visits.visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

-- Records of Stephanie Mendez's animals:
SELECT vets.name AS vet_name, animals.name AS animal_name, species.name AS species_name, visits.visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Stephanie Mendez';

-- Count of animals seen by Stephanie Mendez:
SELECT vets.name, COUNT(DISTINCT animals.id)
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

-- List of vets and their specialties:
SELECT vets.name AS vet_name, species.name AS specialty_name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

-- Animals that visited Stephanie Mendez between April 1st and August 30th, 2020:
SELECT vets.name AS vet_name, animals.name AS animal_name, species.name AS species_name, visits.visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- Animal with the most visits to vets:
SELECT animals.name, COUNT(visits.animal_id)
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY count DESC
LIMIT 1;

-- Maisy Smith's first visit (with vet name):
SELECT vets.name, animals.name, MIN(visits.visit_date) AS first_visit_date
FROM visits
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN animals ON visits.animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
GROUP BY vets.name, animals.name
ORDER BY first_visit_date
LIMIT 1;

-- Details for the most recent visit:
SELECT animals.id, animals.name AS animal_name, weight_kg, neutered, escape_attempts, date_of_birth, vets.id AS vet_id, vets.name AS vet_name, vets.age AS vet_age, visits.visit_date AS visit_date
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.visit_date DESC
LIMIT 1;

-- Number of visits with a vet not specializing in the animal's species:
SELECT COUNT(*) AS without_specialization
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
LEFT JOIN specializations ON vets.id = specializations.vet_id AND animals.species_id = specializations.species_id
WHERE specializations.vet_id IS NULL;

-- Current list of animals visited by Maisy Smith:
SELECT vets.name AS vet_name, animals.name AS animal_name, species.name AS species_name
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith';

-- Specialization to consider for Maisy Smith (most visited species):
SELECT vets.name, species.name AS specialization, COUNT(species.name) AS visit_count
FROM visits
INNER JOIN animals ON visits.animal_id = animals.id
INNER JOIN vets ON visits.vet_id = vets.id
INNER JOIN species ON animals.species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name, vets.name
ORDER BY visit_count DESC
LIMIT 1;
