CREATE TABLE todos (
  id INTEGER NOT NULL AUTO_INCREMENT,
  todo VARCHAR(1024) CHARACTER SET latin1
  COLLATE latin1_general_cs NOT NULL    ,
    PRIMARY KEY (id)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

