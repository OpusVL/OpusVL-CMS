WITH first_constraints AS (
    SELECT DISTINCT ON (field_id) field_id, constraint_id 
    FROM forms_fields_constraints
)

UPDATE forms_fields
SET constraint_id=first_constraints.constraint_id
FROM first_constraints
WHERE first_constraints.field_id=forms_fields.id;

