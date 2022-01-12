from flask import Flask, jsonify
import sqlite3

app = Flask(__name__)


@app.route('/<item_id>')
def page_by_title(item_id):
    with sqlite3.connect('animal.db') as connection:
        cursor = connection.cursor()
        query = f"""
                select
                an.id ,
                an.animal_id,
                at2.name as "Type",
                an.name,
                c.name as "Color_1",
                c2.name as "Color_2",
                ab.name as "Breed",
                an.date_of_birth,
                o.age_upon_outcome,
                o.outcome_subtype,
                o.outcome_type,
                o.outcome_month,
                o.outcome_year 
                from animals_new an 
                LEFT JOIN animals_types at2 on an.type_id = at2.id
                LEFT JOIN colors c on an.color1_id = c.id
                LEFT JOIN colors c2 on an.color2_id = c2.id
                LEFT JOIN animals_breed ab on ab.id = an.breed_id
                LEFT JOIN outcomes o on an.animal_id = o.animal_id 
                WHERE an.id = {item_id}
        """
        cursor.execute(query)
        row_data = cursor.fetchone()
        data = {
            "id": row_data[0],
            "animal_id": row_data[1],
            "Type": row_data[2],
            "name": row_data[3],
            "Color_1": row_data[4],
            "Color_2": row_data[5],
            "Breed": row_data[6],
            "date_of_birth": row_data[7],
            "age_upon_outcome": row_data[8],
            "outcome_subtype": row_data[9],
            "outcome_type": row_data[10],
            "outcome_month": row_data[11],
            "outcome_year": row_data[12]
        }

    return jsonify(data)


app.run()
