import React from 'react';
import { TrendingUp, Users, Target } from 'lucide-react';
import '../styles/Services.css';

const Services = () => {
  const services = [
    {
      icon: <Target size={40} />,
      title: 'Strategy Consulting',
      description: 'Develop comprehensive business strategies that align with your vision and drive long-term success. We help you navigate complex challenges and identify growth opportunities.'
    },
    {
      icon: <Users size={40} />,
      title: 'Management Consulting',
      description: 'Optimize your operations and organizational structure for maximum efficiency. Our management solutions enhance productivity and foster a culture of excellence.'
    },
    {
      icon: <TrendingUp size={40} />,
      title: 'Marketing Consulting',
      description: 'Build powerful marketing strategies that resonate with your target audience. From brand positioning to digital campaigns, we create impact that matters.'
    }
  ];

  return (
    <section id="services" className="services-section">
      <div className="container">
        <div className="services-header">
          <h2 className="heading-2">Our Services</h2>
          <p className="body-medium section-description">
            Comprehensive consulting solutions tailored to your business needs
          </p>
        </div>
        
        <div className="services-grid">
          {services.map((service, index) => (
            <div key={index} className="service-card">
              <div className="service-icon">
                {service.icon}
              </div>
              <h3 className="heading-3 service-title">{service.title}</h3>
              <p className="body-small service-description">{service.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Services;