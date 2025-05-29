CREATE DATABASE IF NOT EXISTS event_planner;

\connect event_planner;

CREATE TABLE IF NOT EXISTS users (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   email VARCHAR(255) UNIQUE NOT NULL,
   password_hash VARCHAR(255) NOT NULL,
   name VARCHAR(255) NOT NULL,
   organization VARCHAR(255),
   role ENUM('Organizer', 'CoOrganizer', 'Attendee', 'VenueStaff', 'Admin') NOT NULL, 
   is_active BOOLEAN DEFAULT TRUE,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS events (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   title VARCHAR(255) NOT NULL,
   description TEXT,
   date DATE NOT NULL,
   time TIME NOT NULL,
   location VARCHAR(255)
   type ENUM('InPerson', 'Virtual', 'Hybrid') NOT NULL,
   category VARCHAR(255),
   organizer_id UUID REFERENCES users(id),
   banner_url VARCHAR(255),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS registrations (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   event_id UUID REFERENCES events(id),
   attendee_id UUID REFERENCES users(id),
   contact_name VARCHAR(255),
   contact_email VARCHAR(255),
   additional_info JSONB,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ticket_tiers (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   event_id UUID REFERENCES events(id),
   name VARCHAR(255) NOT NULL,
   price DECIMAL(10,2) NOT NULL,
   total_allocation INT NOT NULL,
   reserved_allocation INT DEFAULT 0,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS discounts (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   event_id UUID REFERENCES events(id),
   code VARCHAR(255) UNIQUE NOT NULL,
   type ENUM('AmountOff', 'PercentageOff') NOT NULL,
   value DECIMAL(10,2) NOT NULL,
   conditions JSONB,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS invitations (
   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
   event_id UUID REFERENCES events(id),
   email VARCHAR(255) NOT NULL,
   role ENUM( 'CoOrganizer', 'VenueStaff') NOT NULL,
   status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);