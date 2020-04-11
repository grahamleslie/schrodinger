# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Pipeline.destroy_all
Run.destroy_all
Secret.destroy_all

Pipeline.create!([
    {
        name: "Scrhodinger Test",
        repo: "git@gitlab.com:gleslie/schrodinger-test.git",
        triggers: "master",
        domain: "schrodinger-test",
        created_at: DateTime.now,
        updated_at: DateTime.now
    }
])