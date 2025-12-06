import React from 'react';
import '../styles/Footer.css';

const Footer = () => {
  return (
    <footer className="footer">
      <div className="container">
        <div className="footer-content">
          <div className="footer-brand">
            <span className="footer-logo">S2MC CONSULTING</span>
            <p className="body-small footer-tagline">
              Strategy, Management, and Marketing Consulting
            </p>
          </div>
          
          <div className="footer-bottom">
            <p className="body-small footer-copyright">
              © {new Date().getFullYear()} S2MC Consulting. All rights reserved.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;