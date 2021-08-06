CREATE TABLE users(
    id SERIAL,
    username VARCHAR(255),
    pass VARCHAR(255),

    PRIMARY KEY (id)
);

CREATE TABLE message(
    id SERIAL,
    fromuserid INT,
    touserid INT,
    content VARCHAR(255),
    selfuser BOOLEAN,
    types INT,
    timesend TIMESTAMP,
    PRIMARY KEY (id)
);