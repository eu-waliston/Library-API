# script para criar todas as migrações
# create_migrations.sh

#!/bin/bash

echo "Criando migrações..."

# 1. Users e JWT
rails generate migration CreateUsersAndJwtDenylist

# 2. Authors, Categories, Publishers
rails generate migration CreateAuthorsCategoriesPublishers

# 3. Books
rails generate migration CreateBooks

# 4. Locations e Book Copies
rails generate migration CreateLocationsAndBookCopies

# 5. Loans
rails generate migration CreateLoans

# 6. Reviews e Favorites
rails generate migration CreateReviewsAndFavorites

# 7. Fines
rails generate migration CreateFines

# 8. Reservations
rails generate migration CreateReservations

# 9. Notifications
rails generate migration CreateNotifications

# 10. Performance Indexes
rails generate migration AddPerformanceIndexes

# 11. Additional Constraints
rails generate migration AddAdditionalConstraints

echo "Migrações criadas com sucesso!"