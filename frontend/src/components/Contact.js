import React from 'react';
import { MapPin, Mail, Phone } from 'lucide-react';
import '../styles/Contact.css';

const Contact = () => {
  return (
    <section id="contact" className="contact-section">
      <div className="container">
        <div className="contact-header">
          <h2 className="heading-2">Get in Touch</h2>
          <p className="body-medium section-description">
            Ready to transform your business? Contact us today to discuss how we can help.
          </p>
        </div>
        
        <div className="contact-grid">
          <div className="contact-card">
            <div className="contact-icon">
              <MapPin size={32} />
            </div>
            <h3 className="contact-label">Address</h3>
            <p className="body-small contact-info">
              1021 E Lincolnway Unit #1375<br />
              Cheyenne, WY 82001<br />
              United States
            </p>
          </div>

          <div className="contact-card">
            <div className="contact-icon">
              <Mail size={32} />
            </div>
            <h3 className="contact-label">Email</h3>
            <p className="body-small contact-info">
              <a href="mailto:s2mc.company@gmail.com" className="contact-link">
                s2mc.company@gmail.com
              </a>
            </p>
          </div>

          <div className="contact-card">
            <div className="contact-icon">
              <Phone size={32} />
            </div>
            <h3 className="contact-label">Business Hours</h3>
            <p className="body-small contact-info">
              Monday - Friday<br />
              9:00 AM - 5:00 PM (MST)
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Contact;