# Reinforcement Learning Course Website
**Course Code:** 25PE1AS14 | M.Tech. II Semester — AI & Data Science | Professional Elective-IV | 3 Credits

**Institution:** VNR Vignana Jyothi Institute of Engineering and Technology, Hyderabad

**Semester:** II Semester 2025–26

**Instructor:** Nishanth Koganti, Department of AI & Data Science

---

## About the Course

This website hosts all course material for the Reinforcement Learning elective. The course covers the mathematical foundations and algorithms of RL — from multi-armed bandits and Markov Decision Processes to temporal-difference learning, policy gradient methods, and function approximation.

**Class Schedule:**
- Monday: 10:00 – 11:00
- Thursday: 13:40 – 14:40
- Saturday: 10:00 – 11:00

---

## Website Structure

The site is built with Jekyll and organized as follows:

| Directory / File | Purpose |
|---|---|
| `_lectures/` | One `.md` file per lecture and tutorial session |
| `_assignments/` | Assignment descriptions and links |
| `_events/` | Exam dates, deadlines, and other calendar events |
| `_announcements/` | Course announcements shown on the home page |
| `_data/people.yml` | Instructor and TA profiles |
| `_data/nav.yml` | Top navigation menu |
| `_config.yml` | Site-wide settings (course name, school, base URL) |
| `index.md` | Home page content |
| `lectures.md` | Lectures page preamble |
| `tutorials.md` | Tutorials page preamble |
| `schedule.md` | Schedule page preamble |
| `materials.md` | Course materials page |
| `overview.md` | Course overview / syllabus |

---

## Running Locally

1. Install Jekyll: [jekyllrb.com/docs/installation](https://jekyllrb.com/docs/installation/)
2. Clone this repository.
3. Serve with live reload:
   ```bash
   bundle exec jekyll serve
   ```
4. Open `http://localhost:4000/rlcourse-mtech-fall26/` in your browser.

---

## Adding Content

### Lectures
Create a `.md` file in `_lectures/` using this template:

```markdown
---
type: lecture
date: 2026-01-01T10:00:00+5:30
title: "Lecture Title"
tldr: "One-line summary of the lecture."
hide_from_announcments: false
links:
    - url: /static_files/presentations/lec01.pdf
      name: slides
    - url: https://example.com
      name: recording
---
**Suggested Readings:**
- [Book Chapter](http://example.com)
```

### Tutorials
Create a `.md` file in `_lectures/` with `type: lecture` and a title prefixed with `Tutorial` (e.g., `t01_...md`).

### Assignments
Create a `.md` file in `_assignments/` using this template:

```markdown
---
type: assignment
date: 2026-01-01T10:00:00+5:30
title: "Assignment #1"
pdf: /static_files/assignments/assign_01.pdf
hide_from_announcments: false
due_event:
    type: due
    date: 2026-01-15T23:59:00+5:30
    description: "Assignment #1 due"
---
```

### Exams & Events
Create `.md` files in `_events/`:

```markdown
---
type: exam          # or: due | raw_event
date: 2026-02-01T10:00:00+5:30
description: "Mid-Semester Examination"
---
```

### Announcements
Create `.md` files in `_announcements/`:

```markdown
---
date: 2026-01-05T10:00:00+5:30
---
Welcome to the Reinforcement Learning course! Please check the schedule page for class timings.
```

---

## Deploying to GitHub Pages

1. In `_config.yml`, set `url` to `https://<your-github-username>.github.io` and `baseurl` to `/rlcourse-mtech-fall26`.
2. Push to the `main` branch.
3. In the repository's Settings → Pages, set the source to the `main` branch.
4. The site will be live at `https://<your-github-username>.github.io/rlcourse-mtech-fall26/`.

---

## Acknowledgements

This website is built on the [jekyll-course-website-template](https://github.com/kazemnejad/jekyll-course-website-template) by [Amir Kazem Nejad](https://github.com/kazemnejad), which is itself based on [svmiller/course-website](https://github.com/svmiller/course-website). The template is used here with gratitude and adapted for the Reinforcement Learning course at VNR VJIET.
