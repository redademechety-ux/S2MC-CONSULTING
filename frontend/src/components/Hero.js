import React from 'react';
import { ArrowRight } from 'lucide-react';
import '../styles/Hero.css';

const Hero = () => {
  const scrollToContact = () => {
    const element = document.getElementById('contact');
    if (element) {
      element.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <section id="home" className="hero-section">
      <div className="container">
        <div className="hero-content">
          <h1 className="brand-display">
            S2MC<br />CONSULTING
          </h1>
          <p className="body-large hero-subtitle">
            Strategy, Management, and Marketing Consulting
          </p>
          <p className="body-medium hero-description">
            Empowering businesses with strategic insights and innovative solutions to achieve sustainable growth.
          </p>
          <div className="hero-cta">
            <button onClick={scrollToContact} className="btn-primary">
              Get in Touch <ArrowRight size={20} style={{ marginLeft: '8px' }} />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;