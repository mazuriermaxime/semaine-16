drop DATABASE if exists concession;

CREATE DATABASE concession;

USE concession;

CREATE table vente (
    vent_id int NOT NULL,
    vent_marque varchar(255) NOT NULL,
    vent_couleur varchar(40) NOT NULL,
    vent_date DATE,
    vent_prix int NOT NULL,
    vent_crédit varchar(40) NOT NULL,
    vent_comptant varchar(40) NOT NULL,
    PRIMARY KEY (vent_id)
);

CREATE table vehicule (
    veh_id int NOT NULL,
    veh_quantité SMALLINT NOT NULL,
    veh_prix SMALLINT NOT NULL,
    PRIMARY KEY (veh_id),
    FOREIGN KEY (veh_prix) REFERENCES vente (vent_prix)
);

CREATE table utilitaire (
    uti_id int NOT NULL,
    uti_prix int NOT NULL,
    uti_date_achat DATE,
    uti_quantité int NOT NULL,
    PRIMARY KEY (uti_id),
    FOREIGN KEY (uti_prix) REFERENCES vehicule (veh_prix)
);

CREATE table detail (
    det_id int NOT NULL,
    det_option varchar(40) NOT NULL,
    det_accessoires varchar(40) NOT NULL,
    det_quantité SMALLINT NOT NULL,
    det_pose varchar(40) NOT NULL,
    det_prix SMALLINT NOT NULL,
    det_neuf varchar(50),
    det_occasion varchar(50),
    det_crédit varchar(50),
    det_comptant varchar(50),
    det_date DATE NOT NULL,
    PRIMARY KEY (det_id),
    FOREIGN KEY (det_prix) REFERENCES utilitaire (uti_prix)
); 

CREATE table commerciaux (
    com_id int NOT NULL,
    com_particuliers varchar(40) NOT NULL,
    com_professionnels varchar(40) NOT NULL,
    com_date DATE NOT NULL,
    PRIMARY KEY (com_id),
    FOREIGN KEY (com_date) REFERENCES detail (det_date)
);