use trader;
CREATE TABLE portfolio(portfolioId INT NOT NULL AUTO_INCREMENT, clientId VARCHAR(64) NOT NULL, total DECIMAL(12,2), loyalty VARCHAR(8), balance DECIMAL(12,2) DEFAULT 50000, commissions DECIMAL(12,2), freeTrades INTEGER, PRIMARY KEY(portfolioId));
ALTER TABLE portfolio AUTO_INCREMENT=1000;
CREATE TABLE stock(portfolioId INT NOT NULL, symbol VARCHAR(8) NOT NULL, shares INTEGER, price DECIMAL(12,2), total DECIMAL(12,2), lastQuoted TIMESTAMP, commission DECIMAL(12,2), FOREIGN KEY (portfolioId) REFERENCES portfolio(portfolioId) ON DELETE CASCADE, PRIMARY KEY(portfolioId, symbol));
CREATE TABLE client(clientId VARCHAR(64) NOT NULL, firstName VARCHAR(64) NOT NULL, lastName VARCHAR(64) NOT NULL, email VARCHAR(64) NOT NULL, phone VARCHAR(64) NOT NULL, preferredContactMethod ENUM('email','text','phone','mail') NOT NULL, salesforceContactId VARCHAR(32) DEFAULT 'N/A', PRIMARY KEY(clientId));
