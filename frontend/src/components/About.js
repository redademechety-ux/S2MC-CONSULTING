import React from 'react';
import { Award, Globe, Lightbulb } from 'lucide-react';
import '../styles/About.css';

const About = () => {
  const values = [
    {
      icon: <Award size={32} />,
      title: 'Excellence',
      description: 'Committed to delivering exceptional results'
    },
    {
      icon: <Globe size={32} />,
      title: 'Global Perspective',
      description: 'Bringing world-class expertise to every project'
    },
    {
      icon: <Lightbulb size={32} />,
      title: 'Innovation',
      description: 'Pioneering solutions for modern challenges'
    }
  ];

  return (
    <section id="about" className="about-section">
      <div className="container">
        <div className="about-content">
          <div className="about-text">
            <h2 className="heading-2">About S2MC</h2>
            <p className="body-medium about-description">
              S2MC Consulting is a premier consulting firm specializing in Strategy, Management, and Marketing. We partner with businesses to transform challenges into opportunities and drive sustainable growth.
            </p>
            <p className="body-medium about-description">
              With a deep understanding of market dynamics and organizational excellence, we provide tailored solutions that empower our clients to achieve their strategic objectives and maintain competitive advantage.
            </p>
          </div>
          
          <div className="values-grid">
            {values.map((value, index) => (
              <div key={index} className="value-card">
                <div className="value-icon">
                  {value.icon}
                </div>
                <h3 className="value-title">{value.title}</h3>
                <p className="body-small value-description">{value.description}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default About;